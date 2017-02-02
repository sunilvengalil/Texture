function [texel] = createTexel(height,width,theta,bgrayvalue,fgrayvalue,thickness)
    texel = bgrayvalue * ones(height,width);
    %fwrite(1,sprintf('theta=%0.2f TanTheta=%0.2f \n',theta,tan(theta)));
    %lineLength = width;

    middle = height/2;
    halfOfThickness = floor( thickness/2 );

    if(theta == pi/2 || theta == 3 * (pi/2) || theta == -pi /2 )
       %handle 90 degree and 270 degree separately  becasuse tan90 is inf 
       for y = 1 : height;
           
           if( mod(thickness,  2 ) == 0 )
               %height is even  
               for x = middle - halfOfThickness: middle+halfOfThickness -1
                   texel(x,y) = fgrayvalue;
               end
           
           else
               %height is odd
               for x = middle - halfOfThickness: middle+halfOfThickness
                    texel(x,y) =  fgrayvalue;
               end
            end
           
       end
    else
      if( theta == 0)  
       for x = 1 : height
             if( mod(thickness, 2) == 0 )
             
                 for shift =  -halfOfThickness: halfOfThickness;
                     shiftm = shift + middle;
                     %disp(strcat('shift=',num2str(shift)));
                     y = ( ( x - shiftm ) * tan( theta ) ) + shiftm ;
                     %disp(strcat('x=',num2str(x),' y=',num2str(y),'theta=',num2str(theta)));
                     %fwrite(1,sprintf('%d %d \n',x,y));
                     if( y >= 1 && y <= width && x >= 1 && x <= height )
                        texel(x,round(y)) = fgrayvalue;
                     end
                 end
             else
                 for shift =  - halfOfThickness: halfOfThickness 
                     %disp(strcat('shift=',num2str(shift)));
                     shiftm = shift + middle;
                     y = ( ( x - shiftm ) * tan( theta ) ) + shiftm ;
                     %disp(strcat('x=',num2str(x),' y=',num2str(y),'theta=',num2str(theta)));
                     %fwrite(1,sprintf('%d %d \n',x,y));
                     if( y >= 1 && y <= width && x >= 1 && x <= height )
                        texel(x,round(y)) = fgrayvalue;
                        %disp(strcat('x=',x,'y=',y));
                     end
                 end
             end
       end
      else
          
          for x = 1 : height
             if( mod(thickness, 2) == 0 )
             
                 for shift =  -halfOfThickness: halfOfThickness;
                     y = ( ( x - shift ) * tan( theta ) )  ;
                     %disp(strcat('x=',num2str(x),' y=',num2str(y),'theta=',num2str(theta)));
                     %fwrite(1,sprintf('%d %d \n',x,y));
                     if( y >= 1 && y <= width && x >= 1 && x <= height )
                        texel(x,round(y)) = fgrayvalue;
                     end
                 end
             else
                 for shift =  - halfOfThickness: halfOfThickness 
                     %disp(strcat('shift=',num2str(shift)));
                     y = ( ( x - shift ) * tan( theta ) )  ;
                     %disp(strcat('x=',num2str(x),' y=',num2str(y),'theta=',num2str(theta)));
                     %fwrite(1,sprintf('%d %d \n',x,y));
                     if( y >= 1 && y <= width && x >= 1 && x <= height )
                        texel(x,round(y)) = fgrayvalue;
                        %disp(strcat('x=',x,'y=',y));
                     end
                 end
             end
         end
          
      end
      
    end
end




