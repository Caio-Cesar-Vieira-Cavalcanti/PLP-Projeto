:- module(coordenada, [
        getMascara/2, getElemEspecial/2, getAcertou/2, 
        setElem/3, setAcertou/2, setMascara/3
]).

:- dynamic coordenada/3.

% coordenada(Mascara, ElemEspecial, Acertou)

% Getters

getMascara(coordenada(Mascara, _, _), Mascara).
getElemEspecial(coordenada(_, ElemEspecial, _), ElemEspecial).
getAcertou(coordenada(_, _, Acertou), Acertou).

% Setters

setElem(coordenada(Mascara, _, Acertou), NovoElem, coordenada(Mascara, NovoElem, Acertou)).
setAcertou(coordenada(Mascara, ElemEspecial, _), coordenada(Mascara, ElemEspecial, true)).
setMascara(coordenada(_, ElemEspecial, Acertou), NovaMascara, coordenada(NovaMascara, ElemEspecial, Acertou)).
