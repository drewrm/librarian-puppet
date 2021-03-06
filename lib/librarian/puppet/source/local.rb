module Librarian
  module Puppet
    module Source
      module Local

        def install!(manifest)
          manifest.source == self or raise ArgumentError

          debug { "Installing #{manifest}" }

          name, version = manifest.name, manifest.version
          found_path = found_path(name)

          install_path = environment.install_path.join(name)
          if install_path.exist?
            debug { "Deleting #{relative_path_to(install_path)}" }
            install_path.rmtree
          end

          install_perform_step_copy!(found_path, install_path)
        end

        def fetch_version(name, extra)
          cache!
          found_path = found_path(name)
          '0.0.1'
        end

        def fetch_dependencies(name, version, extra)
          {}
        end

      private

        def install_perform_step_copy!(found_path, install_path)
          debug { "Copying #{relative_path_to(found_path)} to #{relative_path_to(install_path)}" }
          FileUtils.cp_r(found_path, install_path)
        end

        def manifest?(name, path)
          path.join('manifests').exist?
        end
      end
    end
  end
end
