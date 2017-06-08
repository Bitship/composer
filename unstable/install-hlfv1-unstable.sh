ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f || echo 'All removed'

# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh

# Start all Docker containers.
docker-compose -p composer -f docker-compose-playground-unstable.yml up -d

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��9Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q��	�F�/�c$��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�Rɿ�Y���T��%I���P�wo{�{�l�\�Z��r�K���l��+�r�SBV�/��5��N�;�����q0Ew�~z-�=�h. (J҅��|R�N�i����(>f���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d�5�*�e����)�E����#���ſԐ2���WGpbCVk"/�A���&0�Z[�Nu��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��5���M�K�����������w�]�������]����u�G���G	{��	��������Eݐ%�/���e�i�<p�!�e���,%>���-3�x�\���2@���d>��4M 3.T�,�x�LMk�y�DC)Ё�sJ[ä���nD&�!N;�q;E`�F�{��3{�Μ��+�9x��n�\�sv?>�;� =.TM(���Q��F�N�$"�J��Q�x$rQ&���}Yn	bG�s&
o��N< :�94��:q���[{(���\C0��)�p#ica���1���8?�.�B~A�'�xh���Tn�pJ�۟i��B�ӛ�B"N�U1"�6o��b�IdJ؍�i�v�k���2uN�em
h�	���\2T�p;ByWZj�����՝)�̵����y
 ���r��sM<�<���i��b���B���J�ύ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q��u�!�%�H�X4�9����l���̆g���^�����6�@����� *�/$�G�Om�W�}��J������_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽/S$y�@�� � �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]=t���[���^�湘[��A+\�����{�Х��Soz�.��Ti�\OT�Z�@a����h�i��iʙ������E�r>� ����Mf��rB�=<�!�|-�t��������L^��B>J$��O'��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%���o`���?IRU�G)������������2P����_���=����1���?��t��e������?��W
���*����?�St��(Fxe���	p�d��CД�4�2��:F������8�^��w������(��"���+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��{�K��3����R�Q�������e���������j��]��3�*�/$�G��S���m�?�{���
���#��fk�/���0�`������F߻58v}&�C\����}@��r���L�1ɤޛJsk:�LІ����CE�ctW$a��:�;^o�a�����5Q�Ǡ)Q/�q�@�:ܠ�ɪc��,�=Ѻ�i[<2.g�cDґ����9��A�6h�p�4�Cr��mEl	`�8�v�vSt���MV&�����-�3�q�|�0�ٓI�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_�����W�_>D���S�)��������?�x��w�w� ���Q���\"�Wh�E\����O�����+��������!���HAť��+���ؤ�N?�0P>���v�����.�"K�$�"��"B�,J�$I�U���2�y�B*���J��*vE~�Z������֘.�m��H�n�����'/H���?�@�N�ǝ:���А�Q����2�F�	�6v�3�J������nO@�C���V>����3�pN)9��ͪ��w����S�O?<���?J��9x����3�;��*�w9�P���/S
��'�j������A��˗����q��_>R�/�X�8�!���R�;��`8���']����OY�,�Ѕ��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#��O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��������#���+������S��:�������������h�
e���b���4��(L���+�����_�=�s�@��8�Z���� sߐ���>:��$��}�g�ݏ��{P����]P�z�F��=t���y�֣<��]"��恆t���k瞉��OcvJ��y��B�NgĠ��վml�8O`���L�z��"<c8x&'8�d�ub�ysD�������⢹���l�LT0�:����=�m�(����1��!1`[���!�0�BK<��9ޭ�+�FQ�5a��7�STY�M9�S�Kw*�vg<6� n-�y��<�K�In{.���}p>�= �'�)gSs��wu��{
mE6��l�q�s�2�)a�l�i��@�=��a�Sb3�=)�h���g�O�֪�Ys�P��ϋ�H���q�w��8Q���෰�)����&|���Am���(C������(U�/o;�ѿ?�1nۯ�x7w��i*�;<;�}���{C��<3���#� �;��s �'�@���-��) ��k����k�$� !Dbl'�����>���$���ld�l�k��e+=5%���ʱkiBÐNe3&ɜ��ep*7<��k����q�W��k� ��	!ޞ�l�C�����}�@�,4GN�F��Y�ͻ�����2�g�d5���ן��v�^�=�K�^����w:��M!��#Z�������g�?�G����A\n�#4U�������'��T�J�g��j����2�������V�����������j�����]Y`.��1�~��\.�˭�������,�W�_��������E=���~��\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�WY`~+�!�W����j��\p�(-S���o�S3��N_`�Мznl[�b�7�H[��ɋ��A4������7�;��%k��0�}����0���C�[WpD�S�޵t����MN1���Je�iͫ�?��s?-��ę������G�I���j�����f���Z���2?�N]?�
�j��/��4�C�km�O�t�{a��I��k�1�E\���5re/��}����N�x����&��UM�.�7<�iv��]��w�:��OOL�t�}�ǿh�$���ש�������ֲI�ʭ�����x׵�����[L~��'?ɇ�}��|�����>�9�v��N,���M�jW�i��b����$��׷~���^����Oo�vT�
׾��T4��ng���w��L��fͭ�.����4DU�A�#�Q�����7�������k_�+���
ߎ�}��$w~0������<��0���*�΢г/w�˃����·��śW[���Q��l/����o���:b�]�E��=��e҂H�?m��7����+��z�T��fw���wӻ]��o����������+����O[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k���O4a���"D~��j��Ҿ����}��?��Y<�4�?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n��ŦR��וU��f9�}�axgkxk�p�Y�gK���=K��Fv�^�5k�M#X{��i�x>nwK$�뙝�)��������d2KQ�D�"�$���A���	�=�e� ɞ��!9%� �%�S�l	� �,9lRERԿ����ڪC7E�����{�^���j��n�L1Pn�j��7�	��d�S'�pSV�FL��1|L&±H��E�D�sA�H2���&3���ڶ���Q5[J ��0�K&��l֝�i�a������b�t�M�E&��s�g:�arV�0�	V!Wq�.�UE��4�&���&�ס�JE+��+��I��a� b�eAGf�4İG6L]���M(�ڮ%���X����;��;��a=��lΔ!��B2g��ܵJPV�*ב�sڻi;�*�ˈ#�ٱP���yKHL��A�7�2�hk��i%>��<�J��%�1pT�� W���C�+g{Q�5%�[S�mMِϭ5]f�&�)qs�4�Ɯn���̩wΜ��)y.s:za�i�`��D�����2;��Ӗ�AMU:re�o�]~�m���N���g�s��t���t�l*�̢)���{6��O8�q:�*h �9nOA@��d�������|8Q4^���Y���,xvE��th��%�?C3��,:AA9l	v8w�U~���-"�-)�'�9Ѩ �r��rWi
S@s0���z��,���uT	�]S�<47v���<�y�`���%�B[�я9(������y�3�� �����������*wM?�L�}<B��bg�P��d��kQQ���8]�r�f�,�:U�
�J�6�t�iyVѱ!?=�(�&=�4=�3�W�td�;��'0'�b���_��"���?����<���H���6>�Ƈ��0�i��X����XCu��XaӰ}]PeN��i�f�ϟ��~:�
V��5�����M����(���û���B҂��N�(=��������������=�j�KB_�!ȍ�w��{β(;˜V�*��Q�ڑ�	�뜎7EI�9���BK�
F�T��2
��#�������[� )�� ok���- V����ڣ�؁�ww8�wP�24�_WpG�Ces�<�_'��N(�N�#IȘ�:��AU���i��$vr)����:h�n��T�ǈ�a���$�/YC�� ��9f�<K�����f~0ͻ�ěyO"ZDTOmVT���O�m�nʊ�7����^$'A���J%�{��"E�S&xl����!'� r�Wd�$���Q���(X\�#�F&D{E���eT���HI�	�&Hp���"_������`>jwo�_�f���x�@���U�@�E5�U���<v܁D��*��c�*�n*u�˪�5���`�M�ܙ�`�ᄾ�[���AE��/���I'��?"S����[iE��"H3��!=>���
�������4��kJG�h�n�|��WU4B�y���L���&����_�۽
|r>4L/�7f�W*-��QO��l�����&7�?^H����;�0����ތ�/$m��˝����?��*��׬���l�/$=y�W�Ƥ3���.�9bIBKU�*�Q6X�c,�&�|��:�O��WNFQ<k
�<����?I�6���I���˝���-���O�I�l�Ol����9���$��[�33��&���h�G���AS1�"�>\�#*W6'h:��J�VC�uE��z�h,�0��R��߆�I���߶fu2����k�&��@$e;C��#�ā<��ƒ�����5�5��ޑ5A��4��B̥Z������Z+��`�XV&,M޸6�	�f*�����L�j9�S`�h'<�MM��U�n�Ua*�]�c��	����yߵ��`����~�>~m!�������nOGKKI��'�p��*��w��cLI���ē�e���V�K�L�)Қ�1+�1-E�/O'�������8N���������H��߰p璂U�������� 6��^HZ���3)����^�L������I3��+2�UM�UU��*B��\el0�v�w�������{fO���wtcy��d~i��J�%��:^���>��xl8-g�޶0��ߩ��8�G3V�|���u��<�«��g��8��l��B�S��s�}�c-Թ�Q�����U�h�h����%�(�)N�X�m�Iw�2��=C��?[�Q���JyQ�%�����gRx��{}��_��ڜ�x!�����}�2��h��m��������qH�Z��.D���dI�9�@+��-|G���q��� ǻw�ֶDS�Lhxj�����H騣:�.+=��N~BN�����'�W���������Ͽ��X����{Ƽ�6:rָǉvl|����&���~�j2R�{uA��� wF�9�!Tn�#����ĩ�7�gF��M��ү���1�k6���5�����������#�F��1���S�|�	��F]�����`�zQ���r��	�V��@9w�c��a�hD_����iTOb�lb��Q��՜"�XI<�&�P�ww���O{�������8N�#|n�&�w���?��k�0||���?H��ζ��D��M�����x
����⥟������v�Q���>��U�#`���8��|U��"�e'P{��]�V�.����V7�#x7O�0�[�p�<:�{��?���_���oU��ܣ�-�΃�{���-��q�i��^�a�Kx�:�S���0>��w���;�k���w�?|��;S�������F0HgD�R���]���,ܘ���׳����\t/Z�l�ﱍX��5{��+�j��ta�~2�gnJl���t��/�@wgЮ���]H�^���V�yLn��e'K��zg�]pF��l�$y_!��3�4_�ӭ?.)�æߛ���j����yʟm��Q=+L�	8{�K�K��tV3m\����p0�5;�c�g���}�V�ў��	��c~��X/}�8z���׊�j4�c�`�Xe3�A��mn��5W8!��b#���kͣ|]��a)U�k�Z�=p����%��#�f�9.�<���j;�O�(�CN��˽����	os��&�un��~��C���O��̐ɰ�dac|$o�78�u�Rɘ-y��=P*�Ʋ�WC�3�sb4#�s����J��{٤Tփ{��8P�}�����T:@��TM���^�՜�
׳L8�$�|B
"<�e���t�ȔRδ��DH�d9���9�:<kV0gY�Nd�P���""�jX�P�v0^.���A$�Ky#-�/jZdh�Φ���i����W3�D�����R���4M6B^�?a���0OHXrk�>��>�µp���{̫q>2�䝙t~X#��^�*�Ҽe�NpX��_	�1%�[�@� ^wq���ڃ*h��:-�y�(�#,SHUA�eYo:Oge)5',3�S�K�%��鐷ا2�a8�u�+8e�P����N$����A��ӄ!,�a�x�9���~`���dD���t)�+T��7����j;Hמ���	K���O����b=!'��
���a�ǁZ"^TbH&k���:,�����.5�����hQ�?>��J��4�c�d��Ԥ@I������ B{(u����'�N�2��&�ex
v���C�N���z��*��ڑZs��A��}b3�k��\�d	�u�@Z�nJ�7��k-�׃R��.4��z$��s�1H��d��L�$,��϶��6>�z>ەitX���KU�U�nb�\�*v����?w�+W^ž>9��3����}����y��W'�l}uUF@[	N���{��N���xJ��c�c/�H���� �W��5:�S�D~����^�y^h�$�/����1����h̽iإ	T��A�:Zn��-�E�H�� /�dš��v�����o~�1nW�a3�M��K_�����s6�� 
��9I��c��^��/��1Q��6�z1	3j�e�`?�.��6䅉�����0X1N��~�]! �����a�M �F�}�{��3���>�!�}݌��r���[��6��͠`�A�'+��(����N�r8�nd+]!���Lw߽�[Y��656��@���"Lo?8dr,D�$*`�i2�q���<��S`i��ﳉC2܉1�8*x\1�(O�c������>�3;��\0���<�.�P���E��ؼR�b�]v��;(���"G��Әt4FT�Ә$kB!�^��j��"!$������a|[j��a���"m����Tz����D�7�D4DD@?���yO-�u�D���<���m��&5���(�v�2�ف@�A�D���!:�e�3m��Hy�,mtٽ�Hq�1&�%ͯ@'%=����_u5���Ϧ��p���aoF��OE�@���z�6UWh�q��Żr�������@R�=���j���ㄚ'((u���~IzJLNi�a�$j�^&&8OT�F96ʱQ�~�k�%���:t*�1�\^F���L��Lk� l���6|k"�+�e;���yX�J���Ž�3��?�N����6��/N$m�N$;�GL%I����'�ц���s�����;�)�<Xj�� ���SA�QL�5(2�
�A�I�&4�?�ƌ`�l,LC�j����S��z(��H2Eu=����#��q�C9�z>Zr��5pPjw��fH����(�!3��Qg�(%�X��&�!��p�`�8,t�y'�u�������G�Ǽ�C���C"�J�:A	�>՘�D�XlF��+��:�y��~�#�*tRP��0�r��	"��E}�4�D�ʾR藏If(���<tj�Z�qt�v�I�%6��5��xX��(ǗM9N�������2��N�T�5B_k����]�oa��sQNCG�gu���Ո^�?�^� ߲"�t��
�&h�k��W��������U(-�X�zðK��l�&=�'\�+���QI�=�Ǟþb��;�^��O����ڗ���� ؟��g��������_~{Yk2g�j���׻m�t:��O��(jM۵D�\�|2���?����^�ܬ���W���������/����6����������k�q^Iˌ�bdv�	}���|����pl'q�t�G������v�$G�+�,����X���B� �%�#� iv�s뤓���׶����ם��.�U���V���o��/~���H�������-@S�h�w~�����ϫX��V]����~�Ï����?��?�����������i���������w�����{���v�ᗇ���B;Ah'�a L �v�Yܸ��i0 B;Ah'�6����yv�e��_�T��0P�=Ƃ���|��S��?C`�go�́��w��_�ӏ?|���� � �u � L���Tg h���"F�Qa3쌯����<fi�53`������ �f4�8BX3����X�ʜ�>�0�Ck/�|��������Kw/�Я���g��"?����(B��f�/��)�8F��?BBP�]kt�����*���
J$4�Zm��X���b�6�ͺ�5
6�����q+j�swْ,~:���uSWr���=.|$&$.V�6��W	��2��k1��G��e����R?���Z��à��\z96�����y���TqM�P��P�2�`h�PL��1��t��paX%aT1�`Q�%IJ�s��J��������2#^��L���;��5{1v��Bu��� g��`M��^�-6�{��]��~�ג��͂�#w}���۳�T�'�?y�n���X�w�(V��]A���"'U�V��\��=�:�]�j�Xϖ�OA�>�4-N������(����s߼��O��Ϧ$���`��M��ޠ^����&U�窱v.}"e�*5}S2/��ss�67�oAy�^{���7۶�'�V-��<W��ӧo��Z���-6HT��O���~꟭ճ�o���]�*[cn[c������m�T���� '��A��Xm��&���Ix��4pܴ�� �![l�<$���������G�D��5��v��O����3����M�_��w|���|I���o���
l`��-�7�O��nn�~��%�X�4u�W0w,ǅg�����0�t���ʲ��[�i���S�mK���úMg�Jw�+w�D"�(_*��L��gO�C���K3�ZM*ߕ���������ؒ�$��>~3�]��"Wؽ�'/z����\tw�������(艋������<s�{N���Ֆ�5X^��c���w`�8����ҍ�ݍ���G��0vw���Kbd��$g�d�G�4�;~��k�s����l�uxs��=|T�����g�T�����ץj^�[Χ�p��2�ߓ�yn�)�(x[{-8�q����Ոc&D������]��:l�ߟ>�0��{���`�1�Ҭ�Ѝ�1ҝ;�B�}���aS�q6E���)�-�>Fh�t���N��)����)uD�̯�bߋN��vZ�3!�����yQ���D��
߳����<�.�0
���忣��<�/�F1P�a����=y�_��O����%|	�I����32.����ߪ��FP�>��R����7z�l�߶,��tϝ��[��C�<�o�a��+��F��a �O#�������X8�e�#� �����1?�����i��0�L�u�R(�PP��Q�bU�Pp]c�2R5P��H�U�HE�0���a�������1���P��jJ��؄�%�bk�v*��\E%	��N'9h,��-src�sVAY;7��E�iS���mko	,������ۮ�ק6݁R���D6�ˈLd]'�U���Y��ۙ��d�=oHP�N�D�h͒5i�$��H�Ec��)z�0�d����G�F�/:��C����q����?����B׃p��� ������c��G�4��0�-���M�O���C	;�
�a �f ���qJ5#��`��4z��c�����6p���������8�?����㿡 *�?8� "C,���O �?<����~���^����ɶ��ϋ��|���*����ɟp���'OK�[�|}Z?z�X��ѥ���{���n^�Uv/P�*�n�:w���l9t4]��r����U/��).P�n#�[��T�G�d ��H�<�������q^~�]�K�O��6��^.�!�jߕ̒=�kPI��ޜ�U�|�K
��8M6����F�z�W�v�Z3�+5���0�&$Ѹ��Zcx��Y����X�6p�'�R�]Y:ϴt��,���r�EOJV���I�3��R���mc����8�(u���?� \�OS��/ ��}�q�=Z�C���0����� �?���`�������;��D�0�?�����߷����!\��q���Q�?����?iP���(F�&���o��)����AS�I ,bҸ�`�Re�J��_WX�ԁ��gB���G�8C��ϗ���PI�9�}Sau�8r
zK��j��,5�M��b����+�g�,�2{D�6#���
?c��>������YN�FZm�&��i{vӂ\���hn�O���p�93��1bΧ#I鶁��k���D�p���7 ��}��q���"�����?��������������q��߷����!*�?8� "C,���^�������J�C�@��垫q��������g����ౄ���j����:WO���K�R�/PN��"�q5�Sbx�w��n�����&�����i��JI�^��Dӽ�Ҟ���SV�I|]��ꍡiX\6M!�5�o�v8��J�L�ȳp��[_a�]<���$��>Hq�Z��k��T��N	��d}-"y����Y�	\����Z�{j��N��g�Y��Hh���(R�_�SF�f�Tz*M�(qB*�uEn��ᅺ2�����p1��6k��B�KM��H�ɹV�tӨ�y)[hmA�H~,�ލ�j�i��g�\��.C�x�Ѝ�������D�p�?��7 ��}�q�����0�����������0��~�ގ�5e��o�cM�?����/��M�?0�c�0���?�������?��߯��#N��"��o���B���h��`�I�J0�f(&j��j�fj8�0,���0*��i�(͒$� ��7G����wJ��O�/���Qd�%��L&E��_�6;J�)q��r���I)�×�Ų,H�Q��@jj۳
IZ���zZ��:�2�n'7�H�VzX}&�YC+7T*���rH�g�Fλ�S��i����Q�y��߳�[�n�)�a��!4��B�[��������口8�?�����F��n��� �/�����	���{Ă�i
�G������#�" ��?j�ǐ�@�#D��`;��������G�?@�3$ă�Y�Y�a1�d1UURc��P�]#XSt��i��5M3qg	�4UCa�@�D�k��7���?��g�����q�0했��2/��y#��c��c���JZr�E��ṏ��N4���|��MR*[��F�F��@1�fz�RI�CG��e�T�-�Ö༚�#¬�tD�"ժQi�1��S�`��ՈC���G�_$�
���`;�������ǂ�q�?F�����i�Z,D���C	���/����C(xn�W>X�����_U��$&�e�Z�i�DK���EFZ�Z�Ҳ���۞X�N��:gAt��(p�u��c��6�\�/��xb{��ʝi��@6�zeg�=d^\rKY��2VҊl�[�=mwLδ���˭3j�!nЬ�U��K�$�����v�.��#W[^�[�ˊZo]��(�Q�ű�g�ޣ��m�dbCNI�w����.��W�.m[iDBO�DV�5�>m[�n7Z���Nr�["�cRpO�P�q;�N����7��j���3q�Q|��Ȏ�\w��x�.-�\��e���Z#����z��J$����-1��	��n٪�N[��T����3�jUY��M�bm�u�U�p{[�L+7��rvi
\2]�!�Yy�r<{ʗ��!��@d�R"�M)T��yR���BsC���[�K�#����:3�y�aqR�Xp&�]^�e�i�r�K�dy�����Z�d�z�dor&�x��ba�������������_,�����CFL���Y0b������/����_n��-\���y�Y��d#�<�~v�����w�影�`l �
��T�����a��Q(+p���������~�ކ����Lj6�^X���Df��8eg�U2��"��6�W���S����0T��3v�l����W�9u�d�6�׊��s�A@7�x�~kw:��?t�9j��F�F5�C�5u]�5�-�5e"7�Nf<�K�^뒞�.��\��-�@N�jr����B-d2
Qo�Ri���^Nu�����9������`;�����m�ł������W(���������G0���������k�v�8���I������G�`�'$����uc�Q����8E�? ��������?� �E��B'��0�D)F�H���`0�DgL��iGp%T�d���4SU��.o�0��������`��=�����\3�H��"��6-�Y�	�nvu-��r�`�e�ae��:����>m�弉��x�4���إRe�Lb���p��Q��m
M�4A+�_��y�J&�=MQ��dc(S���I�źe���ŋۿm(��oX�l[fw`\:������J�a���%�?|�������t 苄8�	k�0���&۶�c�;r�`��{��2ҝK�1��GcA�0��6_n���oZ�|�+ʶ}���cj����Z� �u%K(�����Jln�z�N|�,KHS��O~�K����)��\�k}%|\���qq��X%��z}p;����ꈏoS{p��Ӷ��v�KS�q�h�D.߮��lsMY��u���l�]��H|���J`��ḍj��l����Ę��.�/v�����R�����{����T������7ْ,~��&mߘ�Q�R	����sCg,	���D�k��q��{���q���׺{c[^#͵;!���$.�o���x���"%����r��r��_� �� )�Ң�_��h�~M���ڏm�|��MZ���uP��Gڙ}Pˇ$J�e�ݹ��r��̙3�9s��/������ֆ��639�/vk&2�c���-[O�x���5U�ɷX���:��7��(aJ���������ˍqPMͬ�sג�[�>����?�����?ב.4��z�pP}��_G����K?mj\�����y�p�m�]Gz����	|[`��(u��^�4���h8+jP,a���.P��h� ��܄�-ט�l�볍��~Ӵ4��P�/NV :>i³|���M ��c`!|ԃ|F���O�)�2\������%����#[��#!�π�Mu創+�����S�7'�{��:���>ws� i�ڡ���l�^O�������&��@���A���^�1(�<	���۟U��ٿ��W_l�~��7�����ڣ���ϣ�O#螺�F׾�F�ly:�+ ���~A��@��~n�^F>�y��ѯ�<���O����ۑY��M���d�60�m���`0ٛC��9r�lѹl�d۩A����G|�;v�]��Z�'�(9�]|������P��i�H���G�Q��{R�����6�x22,�=:XM����@W�B�J��j�`�
�a�?�#�X6^9W��R����4/sOe�C��!������X<R�:j���t�w�m��A�%3�b���7§��l�"M�E����w�h�X{�������Ú�k�+�4��VZb����b󾑻��8��w%ILST%����ii������a4MFq���=��7�p{'��	_f'����6}����c�,25l�NT��F.�]W��� ����R�^D��6�4�).Y�z儇#i�tg�;�<_W";��Έ�P��`o�[{�+q/��΀�ʸ�{�R,^�xb�G�B�b�5^��"Q���#���(Q!����9�:<k(VdN��jb���Ý�2J�R\V��^$]?�j�D<�Ht�'�I.F"�R�W�jg���}�Y����l=��F�*�,HO;�
��G�,�+b��̲�)m��Gq6^;��h)-"�QГ��x�P�D�9�x�ZH�*a52�S�0lD+��������L��B �ޯ�FM�[O_�Y����|:��U��H:��
�$�{s�2<{*�$%���8��L*+T)qg_�p��H�e_,�ͶHBc�Ѹy��?J����.���$���ZePm�=�T�5����~�̒Z�,��2<�Y�K0Kқ0�4A�6�7�)�ͥ[#{�:����jȏ{E���X�H1��<w���ܸQkR�}��Ĉ���1���Zy�O���+��D$�O���R�.s�2<{*����1�]J�Y�Pb��`T��\'BE�}9���`�f���ᥣ@$?���D�J�Wm�ƭD9ߢj	b����j�p���6�m��6�r6���-�{����0��:їWG�������ckϢ��.�'�|���E1 �YK�U�Yk��ǭM�q���>�|2L)tn����>�>�<�������C�DaO�9z���>�<G�4�SH��_�}y!�����H���+�+�����7� �ry�c�U��,��d��aS���)��
���[�&n��6����8��gW>�"���'&0w��¼Hw*�54��O�� �����7!��xa�1G�z�o�An������;w��б��a��k �(���et�� �S�)�^�J�|&V%8!ȗ��=/?YE�����I}���^,�(x�ܩ[?x,?9x,+�#�v��UÑ�����v�s��W~�؄#���c��>ih��%��d:��e;�9p�44��8fb�h��-�@���y�dJ rL.��e�\�7��� �|T�JP�N�[؉%v�\'8�"%�0���i?���"Bǅ�a�[�m�����a�}07��Oc�.P�{mr�����0[�Ϥ1��ĳ�6eҦ�DR�T���F�H��ϔ��P��r�P������Z�E�R9:��F�`o�zޖHR1!�n�]n������G�ث�0�� ņ���OR���۬��⥱�+����8�`PL1��±n�-�p�cǺO��W�� ���������Z´��,AL,;� |�R��֤���kZX�s-,��_5���������Z,,ۓ�Ǔ��$R�8G��a��'jR��d;�F�9�Z�j�#'�ŔV����$�,�!��"�O��S��
ѝ"V�,�5�·��ǻ"�ΐ����B���Q����Q8��#���'Ӓ��!
������{�J��N�X$S���x'*�=>���86I�x���KV�ΐY_rQgȉ/$R��+8R������.�$}G4�z�i�>�t�}��2�����]�����I��te���{2ψ�jm�p��B�H�� ^ �H��+V��#Ol̵r�<���&g�Z�p?�W�y�͵��G�.ma��a��7Ḑ����-e�y.l�M�X����Kn	7��6�涋R
���'�%ERiE�4o������|��h�����2#�=�<cDS����	�dը��Yt��EQt�QJ���KQ�9?*D	�Ǔ��c3w�Dv��K����ݗ� �����������������Mx������w��t�D��2E��]S��PB�j���O�l�w���?�%!�kط���0��G����}��k�^����ݯ�j��z�I��2�72��d� ����P߯��+z���-������Q����w���;�S?����������g���0���F�1���%����ӡ�?�C;��N;������N{�㾋k;�m���i�vڡ���f�l����[^c<��U.DnG��a:4Gu�̢�P���^����CM�?��w��-�	�v��m��q�V���j���a�Ggp��KD\G0���z���i���͌�m����?�?�������k�f���^����2��U��.�Z[6l����`Ϋ�/�hyL�g��}�D�g[�m���!�g�D0@������ב�v�p4#�LS �ک�d���#g� ր�0x\n�	֍��������b]j�	���2��dL;��B�q�v���3��P�Z;F-.XǡQ�XW( ��_M+ F) Bg�!�%�u0Ϥ"�\)�6
�<P�<嗓@g�#�ҷH� M�`��Q�Ā<E���j{�Ŧ2�$V���Q]U��e�zm �l�,a��:&K�����*'��e�J�d�����|��s�T9�ρ_q��b�T.��1�Z�f؃D���d�J3��y���ch��Ѡk�R,��"�p��1R���� ���纜�_�4�/�� 8�����>��l��&U���x��(0ʖ<���k�֜��Ӡmk�]��a�6^A�p�IO��UH"(f�T(�(u\:�,���K@Kc�>��d������¹p�Q�޶)��<Re�A�y�ee��kL�D(X�7f�݉^tn`��c��s$����x�<^dY;�Q2���:LP�5�;{�H�u1B�U:,�c���El�kWn�:
/����Ú/3�B��9�
7��G �.�шh'�ǁ�qB�rAT���~³ȷ0@R�zE��(86��	r��3.�/��2	 c�oh X�&��+�s�p2�XP���zF�Fy���i�D	�#�_���(P=�YNp�� ��i<����߯�(��boR��h���K��$ �o�I"��1 ���}St�����s'(����?\@��t:"����*T�rQ����>E�	�.��q���E�������Z�uL��ZBcgM�@0H7�1��60. ��8�yƛ������{�~�c3��#���F����4�:  7e�K�@i$Ћ��R�ɱ'Më(�l��f4�#儕o��0 G��F�򞡇�S��@�,̀i�c��o�A�9�&G��:Η�`d�����m��m87I\�������mx�>t<���x����A:=�"��b����I-��цc��C=ιNC�BF������s ?M2\-J� p`.VFNPpcc��� x���t<�7�
	��`�Y`��<�Z�E9q��� ��V�2�5��)��Q��]�ɠ���ʭy�488/��L��]���L�ihM���)�g7 �y�p��2�`Mǧ�n,�Y0��U�ȑ5M��dXN��"��n��ױU��J�
AQ�I����.S�z0�	z���M,!���λ�"8�Z�Wg�eL�.+�ب[���@�4��]R���V@��Z���g)6��'����%���Sy#�$���:��o8��p8f���Č����Ĵ����J�Sכu��e�dJ3RQ�V�֤���P�#*�g�u��b�S�{:�Z���?�<�p��NX�7� maN ��H��x}�����X`��2�]��0����KV(�����{�yn�$q��,��56ό`�	�J^�{}) 椦8m��B;Π'V�bX	���X���_i;�0��Y�'.#�u�C�����r�c���IQemV��΋���@Qӟ5+:�
��7U;v2FV�{��s����ǗgQk�?��E	b��	ʡ3��@3H��FX4g��K�-�Vd	���
�Ϣ�1I��p��8C��Aon�����	�9imY<Y��x/F�D�Pf.sP'5ޟu�_��;��X��x���������kI������t�ߋ�x��!��yq��b�4u���Y��s#dD{��xj���ܴ�t�vņ
t* ����X.�[��j��{VG閙�	4P��Vu0B����� �nr�u8�����b���&9u
����f�tz����Щ�y;}����l����g���ɔb���f61�#8� ��&�
� �ā�^	�-[N�Ӡ�krC������C�&�2Q��)�LĬc���)>Tn4�;mu\Mq�xY�aRV��6�u$����tƌ4uԢ��~u��0o��0r`��*he�0!�)]�y]�;���U���
�H3�82J�l{Q�Y^�S<tٻt�'\��lBSI����w���#[������L��m���]i6��	oBV��_������~��6�G�I�c<J��(������N��I���Pf���|(�C��FĢ�>��p��\s��|#O�>��� ,�I1�������Ͱ"��"4��7�
:����P+�s ���
=L�`y���� ��%x�L��ZS �zAކ�T�iCjpԐ�ۨ�:���3Tf	
pLC�#�௠~�4BJ!l�����ڀ�����U�:8#
��^!=����?��V���xR�o�
�q���#����vj�x�_���Y�Jv������?Ξ�+����?Ξ�ޟ�9<��GQ.{R���x����F���Cx�jJ۞�n�����03}s��	t���84������%X���9#�snl��!�ϫ,���ڀ��o��$���_0�E��:�<o�O-E+�i�*pZ��Z�,�t^2�C��K��y���K Vf�3Zz�m�'=s��_���R��+��KD8�PT��B�h�o�|��d�M�E��~:\���6dp��m�?0�<��P^�cB5c?y���Q����kN8�C���/���>TC�}Bչ�޷P��B�"� 4�.��?.� �?P�����R��Kiy��3R /ӝ�%�O2o
{t�[��@�X��I��f�_��9[�/�!0*�V�@��z��fu��==����V���0򠡔<��r�]�0�W�C�1��z�kDm�*�5�s���S�ͫ��`$�b?�e�H���Tڠ�	��<�{��ȁ45�y���b�v�Ϗ4p�����W�%��)�:.ۑN�Q���	����tϑ����y��)r���V1����������_�e1����_~��?0��4C����
P���H�=I��ulg`0����E~7�vkN�T���:ב����������lt������g�����R��w��z4hKZ(�_�~K8w�
�r-������:�;B����ӿ�G<�����~߿� �_B1A����B�ߝ�z�:M|�Pkz{��˷A-�E;��>�8qP������(@��!U��e~�aw4���T�ܣ�40֦
��`�Zxx�~�@:i~��_ȦbΧ4C��)3Rn�H_#���#�	N�Ғt��j���`~0/��Fhn�+����2�ah�Y� ��Y�"�Q�#��>�������U���8�Ҽ6��r��7\�Pz�{�[�n���1��P]�����Dƻ/0D�yQD�R�ЎD��V<T�}�(��.'�	���W/4�� 5=�ʫ�tq8�L���!�_6r�+H��x��gP��	����m<�pn�<ȆT��
L���!l�p�h��mA�xuG� ������R�7�E�����D��p��53���J8�� cf�Ro5�L���j���'5I@>j�+'|�?��������_�ڏ��<]��b��\>:�+:'��I�҃�� d�q�m
[�8�m��1��;��9��boa筜�f��1d�Sd�=���C;<�,���-��+{��ޑL�=������M�ؒ�C�%��7�4������xK^HK��u���n�{]�{�h�WX�zrE�ޝ'	��(-kq1t.�'��}_���~�]�\	�\7�:�}�8_·�p,<U��N~�2�+R�z�f[hs��9��a�f�=�Ϊ�DDA�!�+l@k6ݞ�r�����'�wF��!Ce��kyz��w�d9���Oڨf��G��g_��{�%B+ϕ��ɕ��}�2���le`�ʀW����p���g^Z�Ͻ�~�%����=��c~밻�k9�F��2�<�߀�&vܤ���8�$|���1�G��ɣ=�S��k������?@E!�������h�6z.��������`�6Q��7�����|��{��0W��G�Y�2��դ�P�
���
Ҍ �eX8Wk�j���l��S_!U�.J'��e:����w$t������
y�A6&(�2 E	�9��u�!}���"�lH�{$���T6#se^� ";�M����+ $��'FS���`�6�+��\���|U��L��j�?Z&�e�#e
���x(����,@�~��,)�¥�!�n>)�|㗗��������p�z�k(E���#Z]��1��9*��ڡ=��=4H�fȲ�"e8?�B9�lkP�)��Å>C��4��ڰMR�`�J���jP`H�v��p����u���ɗ��� BZJ��%��&�T �M��gh9�Fse��Kq谠��]u�ߖ���1)��1��C\4+�ZQ�Y��T���������~m�O�{��G��+�^~.�~�������&�����?>�������0<�������)�������<���Ű�������$���I:�����&n�S�f��h��G�BB��P_���h�>M����A�9����񟗞�����|���	�D�5�"�%����8���s�Ob��B�������x������K��?��?
��s�1jR�]ד��j)��8��ج�N)I]�R,kPiՠ�MgMQu6��4e���w>j�~*�
��?�GQ�4}��8�W$�j���<YkH�%�e��;�����(Jem��ʹ������_<��z]������T�;��Gy�
}���|��u�>�ŧ�ڛ�V67LT��ӤCom�6k��*-��aO�I;�uG�u��i6m�hۅ�h�z뛦4ݥo$��M���Xn�6����>�L5���1�8��4�:_��x��B�^��av�[�ql�}��?����?���D�������süv[|F���G���9�'����&�&�&_�j�gf4��`������D��9�6�c$�����_�a���9�r=�?��9�+I,����Oc�?
���/���������==pK�Mu��̗�e�ĉ�����$��4�AM\���bP�,��ԼA\jS��;Y�_��
\�?������\�6��e�k��NKn�.!z�$�s���̟��V5�C��s<�W]������P5�s������W,�P�,���Wt{%���|}߀_���r���So9q�.W�#�Ȼ� ��5�^J������@@���^�=��)|�]ȹ��m����n�E��s��+Y��)ww[�����d)��M�I<hɚ����;��(-���B�ӵN��py��K�{vgA��XQ2�!q�e�ɚ'������4��e���y���%����B����܈ol��M}>�.Ft9�h*+v������S���Gs��0X��B����~c�?&���ϭ��������#�k�?v��Cba�c���������?/�����D����`��s�����j5����������8����j��6X��L�LJ�J�U�I6�����*����\R�0ZVe��kt�O3\2��u��H�_�����rMlo�*�B��<ֳ�P�9�'4s�6�wZ"�\ɓ����K�����^�>�y�Sϯ3�L���ݛ��K�+��v&F��lq���Gl�	3iM��Yr��6Ʋ|�g����oV3Ip���J���z�����K������8�?��q=�"��-@1��x��������������_���/��������8����z�ts W�X��8����u�?F{��6V٤)TR�2rm��x؅w��=���p����jâ�E���[���7��;4��˹�<�7��C&Od�Ûڨ0�&z�/'vy��&�5�j�a�Nu���zm���c)�R���7,�T`)&��,�5EV.�ó�Ȭ�g��.B�;��0"	4ߧ9���s�����K����-/`���o{܀,��h�zs�Vv��0��ϰ�RVJ;-!��4׾�W&��1y�v��ɠT%^���ț�f��R�I�scn��t8�Z�e�ϭ6��L�����c�1�K�J�j�X��s�,��R�'t�\l�j�O%eB�/2\�~����S�����\O���p��x	��?�����?�'�������������	��c�?��^>�#�_S<3���?������A���_�'<���s���ߣ�S,�����c����W����Ǥ.�����H��=��դ�h��a�>k��T���O�u&��t��%i*�M�i*Ke�,է�F���4��(,Q����K�?�$��"�7���fb~�XT��}��z���']-,J��]}��IӴ�l�:E5ՁkUn8�f����h���2s��LB���f�Lk-��u[��U�x�	Tgg�T1����ݮ�>�c0ae��l�8�ǻ��e�}
�y�����4��"�����E�����d�r��?���O�/����_#�����o��/�E���Q�/��/q���N�?�a��D"���E�'����?����?}��7���\��� �,�1�_�������D��Y��T&ˤ�YFU%�e6���R���fEg�:G�������d6���UC�f�������_���F���}��Ӷo�Dz0���ݴo�e�6���qs7����J��.���.�\JK��7m�S���l�l�a\%#�&fq,씛���%S���j�g	ʰ�DY-n(a]�q�d]���ޞ3J{�4�����������9���H���?�ĕ��{���'9���+I|�?t��Lb`�ѩ���/���#���*��_z>8���+��B���L��M����%/X��$��<8�>��
q�D�[TG��=`��Lv�T�l���8U-ך٘jfgKx'�x��R���ɂ��LU((��\��cmM.�6��e�k��Ӓ�+zG�$ѝ��f�df��9ʍ�[�ѽ��ҭ^75h�Y�kLuM��V�+�ؖsj#~#W@[L@���m(F$�r��F���V˝'z�G�Ǖl��LZbb��%��<I�2�au�k��#�u�N#ǮkqZ���ڸ]�W��Z}t�������x�����bD� ���󎯡 �77��7/x��J�{���K	9?)�T٠>��s��LJ��%����0y��v}��)T��um�s\{�Ň$� �%^ȉ�(��.�lnd-_ڲ�����ʪ��9u��Ya���QYo[�40�|�(����ؕ~���tm�+���7���)=M�b���΃�B���&W���� �,�����_,��9���"���w1����<�Kq���B^������T�f�\&M�S)��vnw�����_��r~xf(���� �@0���=�C����DI���h�	m���߃ B�����ݍf�[����&U\w�N�Y��b��ȵ��*+�荫��0�D�uƙ�����$�t^���t�9{�7��⏾A�~��߃��}������SDo�K�j�j���RЕ��-즲���8_L
�a�izG�l6��9�)Y$����ʞ��o�V�'�m�mYnQ��=�(�$ѦHIYv7 ����%��`oA���%A�����$��ݭvfX3mI�W�^U�ϪbU�%șa�s\<}qt%�.�Ǚo�ڳAQ8�5��t�����_v*�;����������Q�	����ג>��\�S����G��S>����֒���?Qz�����R���������'=��o�'��ג>��wn	�cL�������5�G��������)�E����M���+���L:��ב��?����?��?��O&���S����VZ��N&�Dv���즥�m���f�4��i'کm)O�D��i��l;Ei<+I�fs'�
n��x��~��d2���Z�
���+/���r��݋s�\����t�\nIG�������ʋlw��?�����vT9j'�����mv��of��X���;j�Ǝ/���?|]H<��JM�e�����̳�U:Q��_��db���Py��Mʧ�ap��C�C�_SU*��sW��.�cQ�On��?8��_�I�BRؼ��p������������=�����
���})�)�$*]�0s��L<l�ݳ�76FId��f�@کo���O���a�Վ�9�Z�4���ؔK��jʮPӎ_\ӻsQ��C���Y�qX���R��m)
Qv:��7RW�c�޻s~�y=�_.a݊p�<oѾ��]��Y�{��T<�d��vM��	���������߆���b��I�T_�������:���D2�����۸�3��?ሃ%ϑH2
!�5r��o�1-!��͑.�]���c6�Hb�v'�Ȧ�	.�ţ�'X��Ⱥ��@1�l�%��B�\l�L��Ũ)�|�ڬ�
�5�4F8�h+,�����D��#F�D%��ApxM�'.=�e���5O\n9Z���b^���D�����c����X�hʠG=}ĭtEgn�V������R���=�
Il8�B `�6�L;���[���:�>���Z��2�����B�~�ע�Ag�[���_k�'|-�8�����7�,���|�T�a/α�fB�P*|��Z�C�Y�_>��k�ۘ9�4�cpvGqM�7�g[-��#(���V����i
��pb����B��p�C[EŘ�X���4Ӧk3w&�F����3e;�#�s�ժ�z1/�}3��ꆭi}��̡e�+A'��o�CM���N�%�9��f���E�3t)֑��ɁB��Qsu��ᄞE�9�~*�R2ӊ�a�1��]|�J/G>�V���R���Rl�˰,�s�6����=��.2����{�T��8R��٥l�HO�����&wڀE���E���i�@lS�e�jk: ��>X-���"��d_ܚ�J� ��U��mQ�DV	8�^Ekp��8�����0v
�q�aY�aV�'���(��'�j�o���Y���+|�������H�3`P�哃���K|��`�	���g�:���*�tZ-����|!^û؍�����`���aV���w��Y��Z�KeNW��Ɣ8�|��i�z�_>8����7��)zP��i�Z��e8���Yc�1�ldЗ|�$�v��B���8����}D	���e�B�)<e�K3�� �He�H�2�lk��Qrj���R�@/����Hd����BTj� �a)���Xͅ�hp6K�=�ó�]��M�w�Z<�qB�[<�P��֎* [{V�עmq���ea���P�k�-���B^��l]4�X=+�
v��/��\%����fp��a�l� �D�V���pⴁL��2N*���Y&���q�1�\�q�G��<���#��0s�_�k�U-ڧj�h@��s̋����XƄ?�6:�� ����죍�Y�	>aV2;��c�'f��ħ0�c�����Gkg�"�%L<��,X���Z��c���)K��I-a�0�p��wM]��<h�M�ן�����������o2���%ž�/�1xB�A[d�G3}��|�9[��Z( I.N6 lg�7�#
t�z�h���%�͒�[��Mt�P�*���5��걱p���ơ5Q�
��W�HDк�h{y8r"#���NL����q�ȟ|4�3�����P� ��+����w
�M S� �D����
���&j�Z��:E4-�0u�90���!Z��U��,�	؂���H.��Cp��E�V˟�˼@�50'�r�\=�_�$rI��'�-B��(��}[ d�ؓ�źM�t�te���SIn�4M���$$\E�
�'8��B4�ܓMK�N�+��BZl�dF��B
5I�-�=�S7��N5#��6������1V���,��xpý�\��A?����A�~�$���,bυ�/d����`�G��zڏ\���a��J;�<fO6"�ʓ�`�:k�F_�$d�xN��P�$F|s=l�FL��M�#�DF�~6,�����\S(�m�"@)2�ʃo��F�C�1��V��L�>�� w���F�]��e�9�u��F6�=�@�lJTM��S��zGuZc\;�O���F��N�6௨�������R5GNl��m=fa�(b��JDn���&yF"7"�ٽ	�w߆#>�A�J�H�Ʀ[О��An�l��7}��k�f���a��D���ĕ�.|K4E l;Y�S%����޴�(����<�!wS#��6�ֵ����LM ��c�g��L`���#b�M=�4�恮l����)1J$�P�5�oJ�`�(�C�(!
y��&b���O���7c���_��cS�hL6��BoE�#�bo��t'�a�����d��Gl�р��FV}8�9��C�Uȿ����m���=f�"�`����G��ҡ֜[�&r��$$m��A �p�=QA����h�E����U���&*�Ģ�Q;:c����fxU�0�P���2�ձN~a��L4i����1U�>�32 @�O|>�J:�GL|����'8�6����� Λל}QV,�e��xK85�8���ͮ��4��h}p�w/��e{��\�v�`{�p�p:��c��ͺ���g��%T�i+Z]�a���^u��X�Q�&w*ȭֽ�����,�.��8f�;|�>P7)�������@�\�O�"[�o//�q�~�s��������%��� D6'Fg�@[���z�w���P(�od � �yFf�{f��t�X��'F��\"�7�l�C��ؽ�58u�����?��n�1]ZD��lz�c�SF�äC�pF��鞹��O�i�������>����u,:�#�����I�`�g���bMY�5E�
=%��l�E[��ST=[z�*�h�3alp!�I��`��,M4�u�e���0N���/\����� R�������w��p��g�"�M��}�l����-����� pjC��*��|���Mғ;]�4]"���8���X����͡�m�$ڞ X�Ǚ� |74�J򏃠hฮ�������t*�����Q�����.�b��G�:-��	PO��r�m���+��/(��}Q!	�����yQ���L����ߤ��:�C�b���t*������"��r�~�@�X��/0��2�HY� ��봧�X�{�Mz��HTo���qv)�f�=����+�gA3��ؗXå6Н��Q!T�*���$+���n� ,��D25��gS���kI���^�iY3�jx^�Q�)d͝jF�b���j���`}ﾰ�����ۃ�Ga�wt����"���.h>Nɰ�8>8�2	`�*����Q3ȰKU'b����(c@ٶH�t����Z���	�J����^��_�������`�Cl�nfn��,��6b=Ʃo�C6Pߍ�걧���=�n�S�`-���6���������%���_ũ�e����s�"qPy7(بB�k�|�/�GI�I�����}���TNpZ���w��d���*��2�؉��z�`EF�V�pO���z��ֻ�Xz�qb���5��O~V��e�^�hI�oIW4H��MvVǜ �Ǯ�@�ny(�D��.���\�=q_��'��N�H��#-?�\��l������_28�cM���qRV�N�ˬ+-/�\��l������o*�
�-���NO�̖�����Xs�m�	A��7���8.�S
�Z��|H�ڇ������?�-��;-��`�w-���C�֣7��<%5\�aoX���[�`o�:a�C�GS����줊�~�]llveTN�-YT ��U��G���E翦���)\��Gqz��o$|�u��#����QqO䋄<���9� �V�J��	�sv(`�y_�'$tӏ�'����C�uvU���z���$�O��'��?�}��ϟի%��=%�9&a�		�&�8>zd���Q��C�"a{��A񅮯},,/�ųZ�~9}��4@�z|�A�ݘh���������jW�~�Њ�^�>�j�BZKS����(����y+�3D9���Zh?`Ze��A���-���Ο���l���%=��{��1���)�3�+�l��D�́���/����΂;vћ�Q%�^�C��W����T���K%�JgK=�Xz~1[��	����/Ux��Z�������o�D&��)�h�Fd�a��i��dZ^������?RS�D"���$��[��1�\|��!�$��Od���FܝV�ҕ��}����c�?���a��84�n�X��¯��g��A�� ���������t�k�]�DZ4���X�_6��$� ����Z��0�b(�����;l_� xӁ�C@X.��sH�Rۛ4�Hi�����RU�I8�c�o�����& "��P�)�G���j:�xT�m�y�)fѤ�:o���F�poN`GD8jLД;w����G�QU�)�������F/\q�V;Uj&�}���t�n�b��¶'6���QQ���#)�(�F�R�b�> Aႎ.�6!Y�)nwD>�v��VV�Ks�,a;gw"�)��Ʋ��k�a�3��`�?;K�'S�l���i R�aD���_K
���Ջ��'?����/��wÿ�ė�L����t�����+f&����N%w���v�L��m����d[������RJ��i���~�Ǎ=��?6��O��7���������{�7o������WO~{��QhT�O~u��_¡߳Ͻz�O�'���Phts͓���O�������_���>������.�/HW�b�&[��!�Yg���+���á{7{Ⱥ�=?<�J'��4�\�������^�g��gW�����R~��R�u�P9(�Y��;�{y*ޝ�������Ƴ�v�p}V�>+Ś�d��u�;�{v;,�
�ɤ�}q��h�޾�.̗���ѷ�����N�&ݞ����	]���Wo�S;���U�ig����e����K܋���̗��j�p������ͷ�[^:��_Vڱ��Nנ��J�R�aH�×����w��`C���Z�x'_�ϊ��ޫNI���n�����W����r�:-_�χG������
�}}�V;�N5}���ҝ/.u];����d���~���\]���v9�r�'��LS<�Ӵ���޵�8n��ni�ӳ��Y�J�S
�H]Ў*�q����N�8�E �8�sq�$Nb�O+�*$x��R�T��J�*���	�j�
T	!
���d����ef5�Vp�y����}r�������%h�Tf��0e7��D���T�j3>uH��	~ow�$�%њ&y��)k��T�+�j��6�K��u`q���2Z�]����&���W�	�c`a�`�t8@#��h挞�m"�u�HSa�sC��C_b��S
���f����1��$���>L/OTQ�4U�K.�,��b�S)y�j/9�������\|'�.�VJ3�O�j=y`��)ب��Y�e�6�͓�Ѷ� �T��4��n'�SRe���E�2a^.��Ĵ�^���J\9{=�f�N��;�	�ĸ%�*�zW(ǒ�������ЏѹNQȰ=���d=��ˤ���6�p�*���Jb��z�e�EpX�et)��η!ssg!/-}�`�"����<@SiS4%����jUM5���t�9�o2p�˔��inB9�hBg;P\�\��+4e2۔��i�ۓZ�ňtO'��	Wu\��w�3�Mm�^�a�l�`~ɓlm�i�8��GsC��7�^�2�˗,G�Z��,w�ak̼���ò>��`b�æ^[\op��5@%��A�0��j�4=k��8m�m!��|R@�6a(�M�VmL'kU���q����`�T(��q�9����)9��"�V���n��d��B��g���|5�+}�23�z�i�������!����Y��ù�%�e���s&du@��r�\��\<�{z��Da��`PPy�>�z��?5���Lu���)�v�

w�X<���{F`QO �t��W��8��V2��1m���a�k�yE�MBk�4Y�+F_`5jB�5��{uFc�\���RFl��z?Ƌ��`���x:�@Œ4�l��ĖrM J�S4X�[�c`9�|���`F�������L)�_��d�I$�Єl5�fzR���f�
ң�5�|;N{JUsK�l8��[����|�`I�
,�-���,��E SnC	���q�LYl�R��Ys�;�b�����A���Ò�$�#���ǲ_�6�L��a�HY]R�>X�V�m�f<���d��(��B�B�P�c`9�|���`Q�=<��7��ڞdVF&.�3Ur��v��i�U�T$���Jc�k��1:�9��1�--)u"~�W�-��39ɖ']�N`�E9��P�v��m�<����%�c�Q{�9ؗ��o��v�-�|����C;��'6o�ׅ"`��=�~n��6vi�����S�z�T��y<A�_k?�dO���1�h8�9k��%z�e�9�j3�*v\��|�	hY˝;_ W�_��o,�,�Ӻ��Ʃ.��������l;ql�^����)���$val߼�q�����?sw�8װK[�������>7��լ�V���9�v1p~|}96��n�����M��U��q����p����o\������b�3�;l��F����q�]� ���"6�߉��������ʕ%���6��6���㡛tSp⛂W�:t��Ȯ�nE�s��S�O%�Nj}v���Ճ^v��v(SR���gݴV�YU
N4GMI���T��蠢�%�R�ü'��07I������,wjp�[������r�T��Z�T��%%F
 |�����eFM�R���� ���*� ��46�U��"�ج�F@�n˽�}8rCf{I��/�Y]��EG�$x�JNI%���#w�>��C��c:n�3��L��2A\_�h�$�َ�u�J�S���#(3�x��Ԡs�6
A�3����|�_�U�p\ٮ�
:Ŧ��$F��B8�)�0�u�����v�S�����b����@E�@=����l�Pg#D!��qb����㓓d�ݔI�[�4'#� ��� $������M�R�)��T�cp��@����.yl� Kz{&H*��H./����d��*g:a	b��}{6p|z��E�º�Aλʰ�wͰ�����&���ҝ3��}ɰ���ä�t)l�#z��ֳD�GFV:��>KмW>[r�`�8�+�n�+w`����H�'�Y�
,I��jmD��9�d�Q.&C�Qo 'Z��0�b8ʚQ|6��8��~(I(�p0!q*�҄jHL� SL9��8b82��=���̋	x���1e�Bi�9ʅ�Ӓ!\]��4�ө�0��^�5�Bdh�R#EBɥ� ���D�\Hp	�-W[�0o�D�kF�\f6U��|W�=U��J0�H��]�j�0�[rڂx1�=�k8�N��O'�,�;΄g�a��@�����~�%e�S'e�J���:%w�m�E��c��.��|)��x41Ɠт-��w`�7ܷ�MX��Wjm8A�]WE/f��ݯ����B˴����a����Κ<Q��p�G�W)��`c����Z���+��(��ٯ�{?~��W���w��뫟|{�i�}}�T�Z�찍]���z�̚u�����$�G���X�?ݝ��|���4}��?�ͷ�+^�\}�GW���k�������G��f������������_/���Z��|�]�v�kf�y�_~����[O~c7�Y���~��װ�������yC���.��ai��Hډ��HډdH&����)��)."�!���Hډ��(gC9ۧA�yj��}ԃ�8���$2�8�Fϩ��ZPY�5�[	BW�@zf|�CWm�����Wױ6�	�`Hg��:�3@�RѣT�3@������A#y���!fX'_lL��]���� �͙A�д 4g
��0g�������13��Y�p���N*���G�P�yV��um���Ȑ!C�2dȐ!C�2dȐ!C��� ��   