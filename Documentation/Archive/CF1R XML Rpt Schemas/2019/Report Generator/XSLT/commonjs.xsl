<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:user="urn:my-scripts"
    exclude-result-prefixes="msxsl user">    
    
    <msxsl:script implements-prefix='user' language='Javascript'>
        <![CDATA[
        
            function myReplace(s){  
                var x =  s.replace(/(in|ft)(\d)/g, "$1<fo:inline baseline-shift='super' font-size='smaller'>$2</fo:inline>");
                return x.replace(/&/g,"&amp;");
            }
   
            function myMatch(s){                
               var result = s.match(/(in|ft)(\d)/g) || s.match(/&/g);
               return !!result;              
            }
          
        ]]>
    </msxsl:script>
    
</xsl:stylesheet> 