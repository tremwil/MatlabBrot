%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parsePolynomial.m        %
% AUTHOR: William Tremblay %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parse polynomial string into coefficients.
% Only allows univariate polynomials.
% Coefs stored in double vector in increasing order of powers.
function [coefs, valid] = parsePolynomial(str)
    % Trim the string and add leading sign if not present
    str = strtrim(str);
    if ~isempty(str) && ~(str(1) == '+' || str(1) == '-')
         str = ['+' str];
    end
    % Match RegExp corresponding to a monomial expression
    expr = ['(?<coef>(?:\+-|[+-])\s*[0-9]*(?:\.\d+)?)',... % Sign + Coef
            '\s*(?<var>[a-zA-Z]\s*(?:\^\s*[0-9]+)?)?'];    % Var + Exp
    % Check if full string is matched
    matches = regexp(str, expr, 'match');
    if ~isequal(strjoin(matches,''), str)
        coefs = [];
        valid = 0;
        return;
    end  
    % Get tokens defined in the RegExp
    tokens = regexp(str, expr, 'names');
    cMat = zeros(1,length(tokens)); % Coefficient matrix
    eMat = zeros(1,length(tokens)); % Exponent matrix
    var = '';                       % Variable
    % Parse tokens into the coef. and exp. matrices
    for i=1:length(tokens)
        coef = strrep(tokens(i).coef, ' ', ''); % Remove any spaces
        cvar = strrep(tokens(i).var, ' ', '');  % Remove any spaces
        % Handle +- signs like in x^3 + -2x^2 by removing the +
        if length(coef) >= 2 && strcmp(coef(1:2), '+-')
            coef = coef(2:end);
        end
        % Parse coefficient and handle implicit 1 coef
        if strcmp(coef, '-') || strcmp(coef, '+')
            if isempty(cvar)    % Entire monomial is just a sign symbol,
                coefs = [];     % incorrect
                valid = 0;
                return;                
            end
            coef = [coef '1'];
        end
        cMat(i) = str2double(coef);
        % Parse variable and handle constant (implicit x^0)
        if isempty(cvar)    % Implicit x^0 (constant)
            eMat(i) = 0;
            continue;
        end
        if isempty(var)         % No variable assigned yet, set to current
            var = cvar(1);
        elseif var ~= cvar(1)   % Variable is not the same as before,
            coefs = [];         % invalid.
            valid = 0;
            return;
        end
        % Read exponent and handle implicit 1 exponent
        if length(cvar) == 1
            eMat(i) = 1;    % Implicit x^1 (linear term)
        else
            eMat(i) = str2double(cvar(3:end));
        end
    end
    % Accumulate into proper coef. matrix
    deg = max(eMat);
    valid = 1;
    coefs = zeros(1,deg+1);
    for d=0:deg
        % Accumulate terms with same degree
        coefs(d+1) = sum(cMat(eMat == d));
    end
end