
ALTER TABLE INFORMACION_GRUPO
         ADD CONSTRAINT INFGRPINF
         	FOREIGN KEY  ( INFORMACION, MODULO )
         		REFERENCES INFORMACION ( INFORMACION, MODULO )
go 


ALTER TABLE INFORMACION_GRUPO
         ADD CONSTRAINT INFGRPINFGRP
         	FOREIGN KEY  ( INFORMACION_GRUPO, MODULO )
        		 REFERENCES INFORMACION ( INFORMACION, MODULO )
go 


ALTER TABLE IMAGEN_CE
         ADD CONSTRAINT IMGINF
         	FOREIGN KEY  ( INFORMACION, MODULO )
         		REFERENCES INFORMACION ( INFORMACION, MODULO )
go 
         		

ALTER TABLE INFORMACION
         ADD CONSTRAINT INFMOD
         	FOREIGN KEY  ( MODULO )
         		REFERENCES MODULO ( MODULO )
go 


ALTER TABLE INFORMACION
         ADD CONSTRAINT INFTIPINF
         	FOREIGN KEY  ( TIPO_INFORMACION, MODULO )
         		REFERENCES TIPO_INFORMACION ( TIPO_INFORMACION, MODULO )
go 


ALTER TABLE INFORMACION
         ADD CONSTRAINT INFTIPFOR
         	FOREIGN KEY  ( TIPO_FORMATO, MODULO )
         		REFERENCES TIPO_FORMATO ( TIPO_FORMATO, MODULO )
go 


ALTER TABLE NOTICIA
         ADD CONSTRAINT NOTINF
         	FOREIGN KEY  ( INFORMACION, MODULO )
         		REFERENCES INFORMACION ( INFORMACION, MODULO )
go 
 

ALTER TABLE PAGINA
         ADD CONSTRAINT PAGMOD
         	FOREIGN KEY  ( MODULO )
         		REFERENCES MODULO ( MODULO )
go 
  
 
 ALTER TABLE SCROLL
          ADD CONSTRAINT SCRINF
          	FOREIGN KEY  ( INFORMACION, MODULO )
         		REFERENCES INFORMACION ( INFORMACION, MODULO )
go 
         		
         		
 ALTER TABLE SEC_INFORMACION
          ADD CONSTRAINT SECINFSEC
          	FOREIGN KEY  ( SECCION, PAGINA, MODULO )
          		REFERENCES SECCION ( SECCION, PAGINA, MODULO )
go 
 
 
 ALTER TABLE SEC_INFORMACION
          ADD CONSTRAINT SECINFINF
          	FOREIGN KEY  ( INFORMACION, MODULO )
          		REFERENCES INFORMACION ( INFORMACION, MODULO )
go 
 

 ALTER TABLE SECCION
          ADD CONSTRAINT SECPAG
 		FOREIGN KEY  ( PAGINA, MODULO )
         		REFERENCES PAGINA ( PAGINA, MODULO )
go 
         		
         		
 ALTER TABLE TEXTO
          ADD CONSTRAINT TEXINF
          	FOREIGN KEY  ( INFORMACION, MODULO )
          		REFERENCES INFORMACION ( INFORMACION, MODULO )
go 

  
 ALTER TABLE TIPO_FORMATO
          ADD CONSTRAINT TIPFORMOD
          	FOREIGN KEY  ( MODULO )
         		REFERENCES MODULO ( MODULO )
go 
         		
 
 ALTER TABLE TIPO_INFORMACION
          ADD CONSTRAINT TIPINFMOD
		FOREIGN KEY  ( MODULO )
          		REFERENCES MODULO ( MODULO )
go 
