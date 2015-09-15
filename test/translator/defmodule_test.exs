defmodule ElixirScript.Translator.Defmodule.Test do
  use ShouldI
  import ElixirScript.TestHelper

  should "translate empty module" do
    ex_ast = quote do
      defmodule Elephant do
      end
    end

    js_code = """
    const __MODULE__ = Erlang.atom('Elephant');
    export {};
    """

    assert_translation(ex_ast, js_code)
  end

  should "translate defmodules" do
    ex_ast = quote do
      defmodule Elephant do
        @ul JQuery.("#todo-list")

        def something() do
          @ul
        end

        defp something_else() do
        end
      end
    end

    js_code = """
      const __MODULE__ = Erlang.atom('Elephant');

      let something_else = fun([
        [], 
        function(){
          return null;
        }
      ]);


      let something = fun([
        [], 
        function(){
          return ul;
        }
      ]);

      const ul = JQuery('#todo-list');

      export { something };
    """

    assert_translation(ex_ast, js_code)

    ex_ast = quote do
      defmodule Elephant do
        alias Icabod.Crane

        def something() do
        end

        defp something_else() do
        end
      end
    end

    js_code = """
     import * as Crane from 'icabod/crane';
     const __MODULE__ = Erlang.atom('Elephant');

      let something_else = fun([
        [], 
        function(){
          return null;
        }
      ]);


      let something = fun([
        [], 
        function(){
          return null;
        }
      ]);

     export { something };
    """

    assert_translation(ex_ast, js_code)
  end

  should "translate modules with inner modules" do
    ex_ast = quote do
      defmodule Animals do

        defmodule Elephant do
          defstruct trunk: true
        end


        def something() do
          %Elephant{}
        end

        defp something_else() do
        end

      end
    end

    js_code = """
      const __MODULE__ = Erlang.atom('Elephant');
        function defstruct(trunk = true) {
          return {
            [Erlang.atom('__struct__')]: __MODULE__, [Erlang.atom('trunk')]: trunk
          };
        }

        export {
          defstruct
        };

      import * as Elephant from 'animals/elephant';
      const __MODULE__ = Erlang.atom('Animals');

      let something_else = fun([[], function(){
        return null;
      }]);

      let something = fun([[], function(){
        return     Elephant.defstruct();
      }]);

      export {
        something
      };

    """

    assert_translation(ex_ast, js_code)
  end


  should "translate modules with inner module that has inner module" do
    ex_ast = quote do
      defmodule Animals do

        defmodule Elephant do
          defstruct trunk: true

          defmodule Bear do
            defstruct trunk: true
          end
        end


        def something() do
          %Elephant{}
        end

        defp something_else() do
        end

      end
    end

    js_code = """

         const __MODULE__ = Erlang.atom('Bear');
         function defstruct(trunk = true)        {
                 return     {
                     [Erlang.atom('__struct__')]: __MODULE__,         [Erlang.atom('trunk')]: trunk
           };
               }
         export {
             defstruct
       };

         import * as Bear from 'elephant/bear';
         const __MODULE__ = Erlang.atom('Elephant');
         function defstruct(trunk = true)        {
                 return     {
                     [Erlang.atom('__struct__')]: __MODULE__,         [Erlang.atom('trunk')]: trunk
           };
               }
         export {
             defstruct
       };

         import * as Elephant from 'animals/elephant';
         const __MODULE__ = Erlang.atom('Animals');
         let something_else = fun([[], function()    {
             return     null;
           }]);
         let something = fun([[], function()    {
             return     Elephant.defstruct();
           }]);
         export {
             something
       };
    """

    assert_translation(ex_ast, js_code)
  end

  should "Pull out module references and make them into imports if modules listed" do
    ex_ast = quote do
      defmodule Animals do
        Lions.Tigers.oh_my()
      end

      defmodule Lions.Tigers do
        Lions.Tigers.Bears.oh_my()
      end
    end 

    js_code = """
     import * as Tigers from 'lions/tigers';
     const __MODULE__ = Erlang.atom('Animals');
     JS.get_property_or_call_function(Tigers,'oh_my');
     export {};

     const __MODULE__ = Erlang.atom('Tigers');
     JS.get_property_or_call_function(Lions.Tigers.Bears,'oh_my');
     export {};
    """

    assert_translation(ex_ast, js_code)
  end

  should "ignore aliases already added" do
    ex_ast = quote do
      defmodule Animals do
        alias Lions.Tigers

        Tigers.oh_my()
      end

      defmodule Lions.Tigers do
        Lions.Tigers.Bears.oh_my()
      end
    end 

    js_code = """
     const __MODULE__ = Erlang.atom('Tigers');
     JS.get_property_or_call_function(Lions.Tigers.Bears,'oh_my');
     export {};

     import * as Tigers from 'lions/tigers';
     const __MODULE__ = Erlang.atom('Animals');
     JS.get_property_or_call_function(Tigers,'oh_my');
     export {};
    """

    assert_translation(ex_ast, js_code)
  end
end
