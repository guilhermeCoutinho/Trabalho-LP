--#####################################################################################################
--#####################################################################################################                                                                                               
--###                                                                                               ###
--###   Autores: Guilherme Junqueira Coutinho e Felipe Protti Neto                                  ###
--###                                                                                               ###
--###                                                                                               ###
--###   Trabalho de Linguagens de programação com intuito de implementar um interpretador           ###
--###   em linguagem lua.                                                                           ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                                               ###
--###                                                                              05/2014          ###
--###                                                                                               ###
--#####################################################################################################                                                                                               
--#####################################################################################################


--A tabela Funcrions é o cerne do programa , ela armazena na memória todas as funcoes criadas pelo usuario durante a execucao.
Functions = {}

local function replaceVar(auxEnv, nome , value)
-- Percorre os ambientes e busca nome da variavel , atualizando o valor no final
	for k, v in ipairs(auxEnv.vars) do
		if v.name == nome  then
			v.value = value
			return
		end
	end
--Recursao para acessar ambiente mais externo
	replaceVar(auxEnv.prev, nome , value)
end


local function getVar(auxEnv, nome )
--Percorre os ambientes em busca do nome da variavel . e retorna o valor da mesma
	for k, j in ipairs(auxEnv.vars) do
		if j.name == nome then
			return j.value
		end
	end
	for k, j in ipairs(auxEnv.Params) do
		if j.name == nome then
			return j.value
		end
	end
--Recursao para acessar ambiente mais externo
	getVar(auxEnv.prev, name)
end


local function binOp(A, Op, Opers)
--dado uma operacao binaria , a tabela Results armazenará os dois operandos (provenientes da tabela opers) , que podem ser variáveis , numeros
--ou ainda retorno de outras funçoes para depois ocorrer a operacao binaria em si.
	local Results = {}

	for k, v in ipairs(Opers) do
		if v.kind == "VAR" then -- para variaveis só acessar seu valor com a funcao getVar (percorrerá os ambientes recursivamente)
			Results[#Results + 1] = getVar(A, v.name)
		elseif v.kind == "NUM" then -- para numeros só acessar seu valor
			Results[#Results + 1] = v.value
		elseif v.kind == "CALL" then -- para uma funcao , processamos a mesma e atribuimos seu retorno a um dos operandos
			Results[#Results + 1] = proc(v.name, A, v.params)
		end
	end
	--retorna o valor do calculo
	return ( calc (Op , Results[1] , Results[2]) )

end


local function calc (Op , r1  , r2)
--funcao auxiliar para identificar a operacao e executa-la 
	if Op == "MUL" then
		return  r2 * r1 
	elseif Op == "SUB" then
		return r1 -r2 
	elseif Op == "DIV" then
		return r1 / r2
	elseif Op == "ADD" then
		return r2 + r1
	end	 

end


local function proc(nomefunc, A, P)
-- funcao que processa chamadas de funcoes , nomefunc é o nome da funcão , A é o ambiente atual , e P é a tabela de parametros.
--toda vez que uma funcao é chamada dentro de outra  , a funcao proc é usada de novo criando um novo ambiente local para essa nova funcao
--dessa forma atribuicoes locais seram sempre locais. 

	local Env = {
		Params = {},
		vars = {},
		prev = A
	}
	--inicializamos a tabela local Env com os parametros da funcao
	for k, params in ipairs(P) do
		Env.Params[#Env.Params + 1] = params
	end
	-- percorremos a tabela global de funcoes a procura de um nome igual
	for k, i in ipairs(Functions) do
		if nomefunc == i.name then
			for j, v in ipairs(Functions.block) do --percorremos o block da funcao 'linha a linha' resolvendo cada situaçao
				if v.kind == "VARDEF" then -- definicao de variavel 'local' dentro da funcao
					Env.vars[#Env.vars + 1] = {
						name = v.name,
						value = 0
					}
				elseif v.kind == "CALL" then 
                    if v.name == "print" then -- chamada de funcao print , apenas usa a print() de lua com os parametros corretos
                        for p, q in ipairs(v.params) do
                            if q.kind == "VAR" then
                                print(getVar(Env, q.name))
                            elseif q.kind == "NUM" then
                                print (q.value)
                            elseif q.kind == "CALL" then
                                print(proc(q.name, Env, q.params)) 
                            end
                        end
                    else
                        proc(v.name, Env, v.params)
                    end
				elseif v.kind == "RET" then 
					if v.value.kind == "BINOP" then
						return binOp(Env, v.value.op, v.value.opers)
					elseif v.value.kind == "CALL" then
						return proc(v.value.name, Env, v.value.params)
					elseif v.value.kind == "VAR" then
						return getVar(Env, v.value.name)
					elseif v.value.kind == "NUM" then
						return v.value.value
					end
				elseif v.kind == "ATTR" then 
					if v.value.kind == "NUM" then
						replaceVar(Env, v.name, v.value.value)
					elseif v.value.kind == "VAR" then
						replaceVar(Env, v.name, getVar(Env, v.name))
					elseif v.value.kind == "CALL" then
						replaceVar(Env, v.name, proc(v.value.name, Env, v.value.params))
					elseif v.value.kind == "BINOP" then
						replaceVar(Env, v.name, binOp(Env, v.value.op, v.value.opers))
					end
                end
			end
		end
	end
end

function eval(prog)

-- funcao que roda o programa. Percorrendo a tabela fornecida pelo usuario com seu programa , considerando tudo
--lexicograficamente correto
--a tabela local Env gera um ambiente 'global' , como o pai de todos . combinado com a recursividade da funcao proc
--e a ideia de ambiente filho das funcoes criadas em outros ambientes, tem se o escopo dinâmico
--dessa forma atribuicoes locais serao sempre locais.
    local Env = {
		vars = {},
		prev = nil
    }

	
    for k, v in ipairs(prog) do
    	--percorre o programa e toma as acoes devidas conforme cada caso -> call , attr , funcdef , vardef
		if v.kind == "CALL" then
            if v.name == "print" then -- chamada de funcao print , apenas usa a print() de lua com os parametros corretos
                for p, q in ipairs(v.params) do
                    if q.kind == "VAR" then
                        print(getVar(Env, q.name))
                    elseif q.kind == "NUM" then
                        print (q.value)
                    elseif q.kind == "CALL" then
                        print(proc(q.name, Env, q.params))
                    end
                end
            else
                proc(v.name, Env, v.params)
            end 
		elseif v.kind == "ATTR" then
			--  loop pelas variaveis no escopo mais externo para encontrar uma variavel, 
			-- algo do tipo sera calculado var_nome = right_operand , de acordo com o 
			--right_operand , toma-se uma determinada ação:
			for j, var in ipairs(Env.vars) do
				if var.name == v.name then
					if v.value.kind == "NUM" then -- se for numero atribuicao numerica normal
						var.value = v.value.value
					elseif v.value.kind == "VAR" then -- se for outra variavel , retiramos o valor dela
						var.value = getVar(Env, v.value.name)
					elseif v.value.kind == "CALL" then -- se for retorno de funcao , processamos a mesma
						var.value = proc(v.value.name, Env, v.value.params)
					elseif v.value.kind == "BINOP" then -- se for operacao binaria , resolvemos a operacao
						var.value = binOp(Env, v.value.op, v.value.opers)
					end
				end
			end

		elseif v.kind == "FUNCDEF" then -- definicao de funcao , adicionamos nome , corpo e parametros para tabela Functions, a tabela principal
			Functions[#Functions + 1] = {
				name = v.name,
				params = v.params,
				block = v.block
			}
		elseif v.kind == "VARDEF" then -- definicao de variavel nova, só adicionamos seu nome e seu valor padrao -> 0
			Env.vars[#Env.vars + 1] = {
				name = v.name,
				value = 0
			}
		end
    end
end


eval(prog)
