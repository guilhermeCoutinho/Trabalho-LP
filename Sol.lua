program = {
    [1] = { kind = "VARDEF", name = "x" },
    [2] = { kind = "ATTR", name = "x",
        value = { kind = "NUM", value = 3} },
    [3] = { kind = "CALL", name = "print",
        params = {
            [1] = { kind = "VAR", name = "x" }
        } }
}

function olharvarfunc(A, name)
	for k, j in ipairs(A.Variaveis) do
		if j.name == name then
			return j.value
		end
	end
	
	for k, j in ipairs(A.Params) do
		if j.name == name then
			return j.value
		end
	end
	
	olharvarfunc(A.prev, name)
end

function olharfuncattr(A, name, value)
	
	for k, l in ipairs(A.Variaveis) do
		if l.name == name then
			l.value = value
			return
		end
	end
	
	olharfuncattr(A.prev, name, value)
	
end

function OpBinaria(A, Op, Opers)
	local Valores = {}
	
	for k, v in ipairs(Opers) do
		if v.kind == "VAR" then
			Valores[#Valores + 1] = olharvarfunc(A, v.name)
		elseif v.kind == "NUM" then
			Valores[#Valores + 1] = v.value
		elseif v.kind == "CALL" then
			Valores[#Valores + 1] = Processa(v.name, A, v.params)
		end
	end
	
	if Op == "ADD" then
		return Valores[1] + Valores[2]
	elseif Op == "SUB" then
		return Valores[1] - Valores[2]
	elseif Op == "MUL" then
		return Valores[1] * Valores[2]
	elseif Op == "DIV" then
		return Valores[1] / Valores[2]
	end
end

function Processa(nomefunc, A, P)
	
	local Ambiente = {
		Variaveis = {},
		Params = {},
		prev = A
	}
	
	for k, param in ipairs(P) do
		Ambiente.Params[#Ambiente.Params + 1] = params
	end
	
	for k, i in ipairs(Functions) do
		if nomefunc == i.name then
			for j, v in ipairs(Functions.block) do
				if v.kind == "VARDEF" then
					Ambiente.Variaveis[#Ambiente.Variaveis + 1] = {
						name = v.name, 
						value = 0 
					}
				elseif v.kind == "ATTR" then
					if v.value.kind == "NUM" then
						olharfuncattr(Ambiente, v.name, v.value.value)
					elseif v.value.kind == "VAR" then
						olharfuncattr(Ambiente, v.name, olharvarfunc(Ambiente, v.name))
					elseif v.value.kind == "CALL" then
						olharfuncattr(Ambiente, v.name, Processa(v.value.name, Ambiente, v.value.params))
					elseif v.value.kind == "BINOP" then
						olharfuncattr(Ambiente, v.name, OpBinaria(Ambiente, v.value.op, v.value.opers))
					end
				elseif v.kind == "RET" then
					if v.value.kind == "BINOP" then
						return OpBinaria(Ambiente, v.value.op, v.value.opers)
					elseif v.value.kind == "CALL" then
						return Processa(v.value.name, Ambiente, v.value.params)
					elseif v.value.kind == "VAR" then
						return olharvarfunc(Ambiente, v.value.name)
					elseif v.value.kind == "NUM" then
						return v.value.value
					end
				end
			end
		end
	end
end

function eval(program)
   
	--~ Criação de uma tabela global, para guardar o nome, os parametros
	--~ e o bloco da função, sendo necessário posteriormente para pesquisa
	--~ quando uma determinada função for chamada  
	Functions = {}
    
    --~ Criação de uma tabela local, para guardar as variáveis locais e 
    --~ os ambientes predecessores, assim, trabalhando com o escopo e a vinculação
    --~ dinâmica
    local Ambiente = {
		Variaveis = {},
		prev = nil
    }
    
    --~ Percorre program
    for k, v in ipairs(program) do
    
		--~ Identificação do tipo de operação
		if v.kind == "VARDEF" then
		
			--~ Definição das váriaveis do escopo
			Ambiente.Variaveis[#Ambiente.Variaveis + 1] = {
				name = v.name,
				value = 0
			}
		elseif v.kind == "ATTR" then
			
			--~  Percorre as variáveis de escopo
			for j, varamb in ipairs(Ambiente.Variaveis) do
			
				--~ Verificar se a variável está no escopo
				if varamb.name == v.name then
					
					--~ Identificação do tipo 
					if v.value.kind == "NUM" then
						varamb.value = v.value.value
					elseif v.value.kind == "VAR" then
						varamb.value = olharvarfunc(Ambiente, v.value.name)
					elseif v.value.kind == "CALL" then
						varam.value = Processa(v.value.name, Ambiente, v.value.params)
					elseif v.value.kind == "BINOP" then
						varamb.value = OpBinaria(Ambiente, v.value.op, v.value.opers)
					end 
				end
			end
		elseif v.kind == "FUNCDEF" then
			Functions[#Functions + 1] = {
				name = v.name,
				params = v.params,
				block = v.block
		}
		elseif v.kind == "CALL" then
			if (v.name == "print") then
				for  p , q in ipairs (v.params) do 
					if (q.kind == "VAR") then
						print (q.name) --~ aqui vai entrar a recursao para achar o valor da variavel nos ambientes, n dei conta de fazer isso ^^'
					else if (q.kind == "NUM") then
						print (q.value)
				end
			end
			else
			Processa( v.name, Ambiente, v.params )
			end
		end
    end
end

eval()
