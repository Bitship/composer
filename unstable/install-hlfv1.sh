ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.13.3
docker tag hyperledger/composer-playground:0.13.3 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� B��Y �=�r9v��d3锓�*�M�	�v���$��7Q^MM�*Z"%�$K�Wv�d���R��[�����7�y�w�� ݼ�ɒ�1� �胃�܀>8T��D�O��6�����^�Ď��{-�����H$D���0���`H�<�b$�D�gA�%�	���űlh��6aG���-{�+-dZ6v���Y��h
�v8 �'��~3l��<7`����Z�I]��F���:2��c,�@�ش-% >�b[�v����F� (q�;:,����|:��?z �~��W��Z�x7Y?|�B6T�	�l�M	_͇r���d&��)�-��4@��u���ٴa��\)�����F��i.�	0р��tv.臙O��q�7��dҎL\�t�x�o�zVMMY4|Y���mwA����4k:�_X��&M��:�"�&�C�dc�����l��,�JVQ����_���C�9(఩"����5�?�C\��S��f[�	<�~t	[m��D��0�i��g��P\���&jP��U�jg��͡Ys��E��b�e0����&�W����-��h?���C�F��&�� ˮƖ�bf�t�q�a��b~2��M����0]��a�s���l2���tt�z�K���d�v�{�����ا���§��:y�hx��G���EQ�����' ����(_��7c�mD�(�5\���탭x����D�?I�"�b4$E���*ʳ�U�T���,�
��M��쟪�Tc���q��w^:��w>�x�����Uɧ���!q6�|����Xf�?�}���U�Ei-��(k�����oC�	��aa�A�`�����$���?���+*t�9���d��;������G3Ho#�X�l���`Α�a���:H�mz(F�N�mǤ;3�߶�u�MI�M�*�皍���4`x�S�lo�;~`�-y�p�t�yFic�[~ڞ�6�<t�6�Ϝ^�>]S�a��e"5䓼�(z�Dv��h�Ϗu<���c��4��Ԏ����	�(!�in#����^)tg��C��t�M��u,_w�6���?z,�.h���h�B$o�\ӟ���p��j}�+�}$�C�#8�Yx�Il�ɠi�gQ}��6��,��ɺ�do���.��$�tR�K�(���e����做c��|`7����h��D-�A��1ͨ�^
Yܰ�e���w�qG���M��h[��q��j��&�D�A~�x|xMQD ���O���!��f?< �K?� a؀w.����d���F:�&;��Ks{/�A��M�f0��W����,����g��%� �@�sA؜�������儻��Q��v��=��ve~l� ��4�.��̲�G�q�������8z�M���z���I��'�\�t�cE�`�� AWp4�5����|��2Q.wT
��G:�ґb�nCS 3��x��h�n2��6و�f��7�<���<D=h]6������5!�}�J�|�`�G��l1qz@�D����p��!�;5�o6`�8t��^=��©�@k�����2҃���r��H8*���*�����.3������CRtZ�����j��'%G�0�w�-�3���Ӯu�L���v3&��N�c�����f�Kf����N��^�t^J�G�ݟ�nB^3�����������1��Js�}W��M��b6q~�*����������9� @��cX�~E�t�i�ܰ!I#��d�]/��C����$�V����G�X�S�Io�,���l.uX)ϧzl�blZ�,�jm��D�]1쎁��&�}�w�/���s�G��{���x��้��`�%a��\Rw@���N��L�������@�m�,��N x�J���_�x*�;.��lA@�I.�#6C�+d�`��N΋軏5���'	ѵ��������2s�M�!7���?(
��_4]��*���?��S��gF�4�,����m��v	v� �Y��ֹw�!�S����X&�^��x��@���+(�ן�p��w^�Fp��+)�]��/;�����#k���2��7Ew�� {pӲ2Ml�mS3l�h���st�Cj�M�u����1'{�?;���Z?/>%��1A[j86{��p�|wIO���g٨h���u�9Ë��������tp+�jS5�r��s+`J"�w읦��� )q���5���{f�[u�b�pO]�)�э��c��"�L�V& 㯃��9Sm�w&p���L�fw��#h�]��B����OP�2�M�����[���/����D>R��B��x!"6������Q)�큫��� ����8�^{�a�'���^�w�V�ѹK�������P�M��m��>A��?�Lɿ��%�����d��-�ްAuH���~�Ox<0���v�n+��y)�4�72-��hp���r_�����]vCd�3|z?��v`� �|ƞ2:�F0��k5	��מ��S�3  �mD	a��0xC�����Bt��R�i��-gm�]���ҌgK����ڽdFY#�~��-�M2�%��x�;�StL�	��dB���8�32lL���9c���d�cL4˅19ԩD2ϯ�s���2���˕2�g�
��9�^�̬�KhS��#��Yɼ[�Ռ��/(<�7_nm��������B���U�;��H����o_.�.����B8:}����+)��}͝s������?�������?Lٟ~B����BRl������Z�R�c�H��BR���B�P����c1��K��px�?����57�xC��W���v[׈�B�n�y�x��s�K`�¦�9����'nc`�F����W�jɿ��W#<<���庳6�e����7���d��'�7'&ټ���6���V���6��*0?x�oG��^y��]���{�>����Z���|���Mަ�%�_�����\��U�ko�5�@�n54��w�,��&�+���A�n��<���t��߹�-�N�ٲl�c��(� �
(��%��k�1TSB�m%����Dd[��	
��0V��`(��.�!�k^AD�֨����Oe�y�H��t6!�S�����f��DBVu�����lQ�;��q�eO�3=�6��TS/t���>>�^])�U�R����b%o��ǹ�ԕ\����U9��7��U�q�I�2}!W�gJ9yL�i��{Ci��SI�:��/3e���˩L�wv�r��6շq���J��^R�.L������Ak&dw���se����J�rV8,g�Zw��A�{��"^��n�p�<.2����U��#GG����Rڂ'g�n��S'�x��e.�ިHi'�:띞�/���E�*U��!w�'���O�2�#W
�(���̥~��w�����x.�}̔r��\Oe	�s7�'Y9�q��/�1Ӽ,�s���Ϳ�N�O.�v$I��X~�3�'�Q�X���}y?Ւ��sѳ�Y���Η�Y+�#g�T/S��_���"kA�U��T<�-�5ޫ'���b..׶S�,������ľ����3�D��x�a�����v�H@�B"�iқ��r''����
&d�.�R�D��Y���{#����OQh^��'�@�8{Mfèd�T�ǱNBԳ�Rx?�[�7=�q�S�n.uJǹ�#(h�D(���JQ�}o0�O�3Ā�����?��6���|$3������/�nnȡ/ �bD�<�D�D�c{ܲ��������GS�|ˊ���?8��'(��u��Jʘ�tT�� �S���)��f��M���xF�B�C
uA�v��XĴf5�;;������3'����I�\���4�˕���IX�J���U�Wi����:�:~YE��\�Y���^8��p�xO�h�D�Ĩ`�%$AE$+N� �WP�s�K<冖���>���r�/���n�������|6��T?�����/��K���:��Jʸ�����q�nvS��=��#!�G!I��$u9�]3�NV`9�&wyRw������|����Y:�L!�)��u���Xc������m�-C>��ֽb{m�^�¤\��7�Ӕ}�Y��O��^��4�����=x�_	["�������:��j�3�����"���f��@�uP�u("���{F�,��o}n�[�{�[Ӑ�F�o	�=\!��C7�Ь[<��$�i��"�p�FuAC�b�hA�i�/j	Xe^��1z�O�<,r����p�@��Ψ ��5c��W����b�Km��U,!�k:���t�e!HT���F`,��#Q�H���l��<�yxF���\L#����<���Ge^�~Ĺ�၏;���b� [Gk7X��a&Yd���^D�4�A��]���L�ᬠ����j�d|� G` ��Bt��.4X.%RʈL��+W]6lz �&��i%��65d�)bFu=ڷ�Q���ŀ�
]���ٔ��YD�l/�@����~a�� �����J�?�'A�.ol2��-F5Pn3�Mh;�AL|SSU=C����M��������rWG�D�31c}�����o.'���B$^n�*��@�'sہ�CX3q�C�<DM/I��DD���0�զ��Az��h�=�m�W��1��Z��=���91��P�W��JQ
�&��ŵ�]��}0��<�"�f&IUhΩ�z<�2����/ĵ��ѽ�I"R�hay��]���� Dآa�,rY�y����oJ��q��՚���7�w[	T�$�c�>q�v��!Ư7�KJ��)�R�,!�d��^�W�i�"���P�%�,��[:o�C�w��^�j�MG�]�TT6k���<&�=ԍ�ڡ���Ф�-�v����E����8�#P�v���t7�5���&�S���^����l��	�2$s��~��#^������s�:�˶�f�s��N�+F"C��K��Y�L�>���⣉S�b���7�	��@E��,pN�1TU&a��X��#QĆ;�@K6џ�[G�Ж�����>�����k�uK��=Msq7=Ej�A����F}��#��\���c'qn���dq��N��y�؉�,P�@H3�H�b7#�!1�0,����b�!v�|�q�]�[�sZ}�^����:���<�6��A�{I��G�P�K��������_|{�W�����s��������_��7��K��q�s��,��8z����:�1�
�n]C���ga*Ɋ�I��"����p�)��B����12܊�BFe� ȶ�r���$��G�������7��'���G�����}A�������!������}���V����﾿`�������{���!�5����������i���� 톋! -V h1e��
l���F��cCK�R
���&�ҧL�s���r�B��{�����«\p�CW5�e�
�ݨ*�%0#�5�:�M��i%ab��&�^}.�
��kHֳ����=C��0�/鴍@���V��`r��x����|��́��u3A�w)��Ek�Nq��6�q��΄b�L�0�)7g���A%\��f3Y�։�!M3فyX��g{��;�5��~���:�F�}��_���@Μw��s�0���X?ŗF�˗ٱ�k�A'r�B��:�7��2���J��9S��2ee$�R�-$0��,by��B�Z�Nr �Q�K[�#��$�$��ɚ0�hg.�4��-�1����)t����Gt��"n*���� i�I�;
S�_-2�a����71�lѪ�H��b�C�r�`��d�j��X͔��qg��r��/O3�N�OִV���Y�T6�tr�g�&%��Frʏ�C
m!Z�K��l~�]���t�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%�py	c0�"o�R4x�$��?\�(%��cO�p���cLo�S�lӊ��b[���vV8�rr�D��A�C!U���A�ꉚ)��n����۩��?�n{���C������9Cd�x6d��FU,�zm��G�j���M��	����sS�<N��p�hjr,_���hl��6Y��V?��n�~"��>�ӱ0&!�2��-k9B�©�D��&ފ�<e���s�B���S�p,�#S.�|&;��ә2k&��j'�.Ȑ���d?�ӵL���Z6�'.�;��T�Q�MZyD�ڬ�����,J�K�̻��z�������oY��q�ڣ���-���
`�^�/���^	��g�{q�\l��a~���E���;G_�}���C��5�S�E/��7�@���˛�7�y��X��> ����� ��@|�?�ƣ:��<|�a�z���?�R�e��(������,'�*�g��,)�(��������u~��K�Ώ�|�2�`a9�,%r�Y���+���X�~Ʌآ�`rGt�Ʀ�	Lٕ�9 |�
L��H�L��(�Y)�aL��,�T��*0K<��L�8�>f�y%�+ 1*��N�� ��߬����o���E�M�����1o�i=ڮ.k�D����te�GM�&�9[�D���jY��I���d:u�N�t�o0"�i
�d�SP�8#5��@eh����v�8^9�D)9:�$�|���Q�J����>E�e'��Y��UZ�)�~��l�b�<TpLTj�p���,�F6т>��b!���Ƙ^`�8�e�J7�)Ǎ�0S�{�0����N|�ۿ�x�[W2M�M�P.��(ϗa��p�LN�L�����p�_����M9��+����]W?"W1�+r!��/�=n�e���6����3�{fVz\�ew���;m�]w�g��~��M��pĿ�\�C˞l�j5�7fI�g�D=���l���Ò�͠���Z(���2�g�S�(F�,1��\��<=���^mdi�T?�fNߡ�Z�M�P�lC9.дyj3K��L~Dw���@�:�|��$R�YGkO�#������Z�`��|�O��-U]�*,�.-H��V-�W����NU�bYs�Rd�F�P�7�yC�R�bQ��Ê�h2�l��)��"t�5\�W�u�~�1B��Q4�,<��M��W�DV�d�R$Bv6(��552����RHزJ�&�_E22���H�	�~Ԑ��I*�G0�2AVv��D��c�2)s�U(��{�B)���B��:���uJ+�9$O�j��pI�?��:ݮ�Y�P�;�<Ǹ�ѱR=�������V.�*�dH[F�3�.��Qn�PW��P(�r�.������piJ
^ԇf�����y�S�y�� }),����)��f�R��;�4YhΧ8)W�tC�k��<O�HX#H���&��Q�1K�:6�MS`��QXbe��Bl4Z�X)�j9�2f�����.����,��.}7���t�
��x�2���|�B��K�C�-*�1Q��b�#7�_F~��*C}����xxySi#/�c�g�huK�R	�x�y���s���σ^�o!��<��()�n�M�b���S����Q�4U�}H���5�I\����)I!ki�3�*��i�8"�����8Xɐ�%��s:�Sw��V����G8�C��D�uE��Gȇ���)z��p/r/�r��f�wHwI����D��z�_�����Q�-��~�����r�@}�l?t\�:=	�j��@��kH7�˝AM%�@/�r�ke��G���aU�Ki��]�ȍ;��� �H;�q9#�O`�E�O�#c��gv��~��������?uް6�B_ː�K���<~�:����>����غ]�-z�:@N�J[Ŝ���Ɏv�l>P;������cu�euɆ���ãqя�E�#~?zX҂�c�|�� Sk��~��B-� �g�+bw��/��7���B;�z�M-�18��b�`��I0�A�;�jrp�X:
 ���T���Ԟ���pe Y|�B�Al��ja�C�٤�$����(�Џ�����p�Dd-:����>�����Z�i�zW�x��L����w��~t�W��"5�Z�,� ~Ҋ�y֫������U'.��&;��X2����ں���x��U��.�#��+b@}�&:���Y,@'�L-�q�Or+! l��D�Ա���#�F���������	�˭~f@�����9���O=����3[��\;ؐ��_����bS��_��,���UM��d����s��EC��ӡ#�-��6���҂��u�&����-o�C�b�$4`en��f#�O�(�-`��ɏ ��$~y���|.��t��qp��"(�fK�-�x�Kv��V�>aP�:W�&���+���h�R����E�<����v ����{���]�LR5�2�U�?��!��q_j�%v�4a� ��m{[�'<	^��v�O1��1��_i P�P�X�A?MI�#�T�l����Y�I���k)�΂�������2k��I .�rXǚF��A�.�����:�v5`U;V&k( ?��=n�ܩ�!c���5�SK��f��aM�=W���v� �p?2m��_Y�LTI��%�����ӕ�s��Zv�E���]Z_�b�F��ދ޿ �>��	p�mX���n�����!�"T�i|��U��m��j>���&�ĉ�3#��ON|-3�Q��Ú�C��y�M�$p��:��u_Eٜȝ <t�ϟ���Ñ�n��mm�i��<�@���#V��9�1��.���E�[@�BSv6��
t"��{��}���f*�9����n)�pḡ|zl?�@�)����1����Zl�X����:�����v��+۸��?!6���v8��G+��$��l�dG�[V�`j'��2�6<�{�	�)��8}"c<C���Ρ�K\���oYڪbGg��.+>�%��5_�Z���>+W4t��o֎D���T���&��D��٦�v���q9��%�h���c��l7�1J
���DPҙ޷P{���A�;�
|����n�I+��fl�7��z����(v,�7av�}eq�*�ԤH��lb�(�%'�p�b�$QT8�D�(UBRS!$��5�ј�(�DI�51�'M;��	�96�O�O�l�,�m����)z�sKBO�;g	��dg�=�]Tleܵ/�Y~G�+8vW���6Wd��E�I.���Y&��p.�LV��������ei�-r��3ZW؅���%�$pb*�>�G�Wd��^����.T���<�>��]�D����@�g]�\T���#;���:hg��P}�B;�ѝ6!-m��:Ӻ*v0:�2����m��6��ӵ���vn�(t�	�nus���w���KS.&��(��{<W� �'�l�,�q�B���)���s�*��,ǔ��Y+��e�9>+>���	����5:�&�d:tl����>aI���E������v�l£�;����U4�+��\6�'ϲ�X�Okt�\6:�_�]ot�u���L�S��<-��yt�c��"pl�*[i����H3t�{!OY���\9�bgL�_��S�X4�B�����Q��3{��䳶���,��/�7��]�����������͢��m7�o��-ۅ~Lv��
�.+ce(�g��;�ڼwI a�R�nm��\��
ɻc����p�8b��r1c5�8B
8*:�����n�߮l�n�%Lb�C��}�;��6��h�����w���H/|��d�m�?DD����#���I|��7v�����������t�������������B����*��6�?	��>Ҿ�?�y�'�����lڗ����/Nn~�����}/����������z��o��Qz%�?rG�������/�O�c��l+XkG�2nɎ0���v�l)�ԊE�xK��X�j��H�	G�&&+x��Zg�ˢίvz��!
߶����|��f����4��5uh�ÑVF��s�"��є�0p��Ns�|]W��ʌ���J�s�]�� ��R�9,�"ch$[\�O�Ѳ���m��!iY�����I)]�M:�⤫��Sf5IƻcTc/����K;���*��������/�ml�}��v�}��m��q�p����*��q�:��}�}�����=��|:�������u�GF"���t�� ��{
��� �����?�>�9��{I����Wq�pJ��t����򟤶�?u���H����~?;�D���%�/��	jK���޵u��m�w~�yw������qSA�����xEE���VŤ;�]I%��5�*�RE's͵����� �	Gu�Q������x2�	�� ��P����o���3���!�����B�����$��V����V�G����J7�/x�m�]�1��-���ϲ���А����s[��~d���ft�w�~�V?���~E��dVS������}b+�$ة��U��J�{�6��n��5s�c���f�N�s��J����Al���x�i�lQ�Z��&v�)j]�����{����}��g�?�w\���q��6��e�EJ�'K����t��/���{��e�l���A��jl��������\v߈3Z�g�2-��1���d��ƶ{��-/���u���j�kY䨘57�Qn75� 	���ڀ��{Y�@��{�?$����-������D��$����+�?A��?A�S����G����<�a��.@��{�?$�����W�g��� R�������@�P���}xs�߹������9�Ω��9K꺵N��:�p�������k]���/���b�_�co�����qu�g-XG��P^�.8X��F�1�gZ����.�y�Pl8�Q�=M�ₐKA᷻Θ�����2<���!k�������_��H4�⥮W_wdC���_J�Uh���6>v��k߾����-D�N�NIb:%��i�]��6R�h;]��)��LJ2�mo㶘�}�L���"4iI��+&{¨��&�i�|�!��9����7 ���'�� �W����}������(�?��{�%���� %�����1q��1<�<�3�DxD|��!�K�,�T�TȆ%P�pF������5����y����9��A��4Y,Os��/�s��u*:˖1��A[���o���ޞ�������Uw/rv$䬍M=o����)ܦ�͖��|�)q�����>�D�,Ț1��������+P��C�g}���XC׷V�p����> ��0�S�����ǵ������C�W~f�w4-�9�j��\lcGo8g�L`�Uo��ۥ�-CƎ��x�����Ց�	盗��
��m�T�\`��NBY>{4���a�S�)Uܑݸ��3?6{�)�"cKq�n:��@���@��O��[������W|m�@a�����������?����@�$��=�?��W��^y�1�%�Ӈ�,��q3�zg�P�<}���-k��/��=�����Um-~� ���8 ���}z�U����:\�O�*v;��3 D�4O顫��F�Rz�n����sl�h5%�[h��vi�ʰ-�!و����Q�58������υ�]՛�_
�a�Y�^X`�g=�w���S����<_�v�嶤���^�Ֆt�������/v�q<���i$)O��}7��k<oN����M��sC�_7,kaH�����D+�_jRƤ��7<�4��jɚ:�q}�ZM~v얡ԘN���$ӹ���X��w����~OL�e$4#;�;�b��a�z|�c��ϒI4Ǘ���ws�E�A?�4�*����Ї	tQ�����?�0�U �'�'������?d�!����;��_����x@�?��C�?��כ�D��M�D����N�87�g�!���,-Dγ|D���v�O��"����#X��0�P�?��š�S	~������R�\f�Yx�1I@�F�|V̂^��]��A�}����J0�bup��^�Vk{�q��O�b�m7��ϒM���qR]X���2bqѥג����c�.)��{Y������Ԧ��
������*����-��g	�;Tq������@������*B5���6	d��������z�a��&T�������v0"����7��b���o������e��<��#�q�5��%�pI������wX�2����}�[%��#�߷ǰ��������.��5�1#>�TK���w���g�"ګ����w��I2��K��*l<t�Rg�[�G�z�Χ�.�-f'	cp�e�6���l0d=Z���B_:��3D���z��k����vb�ƹ���󏜤I��V���e;
5����r�5��th�?>NeǢ���f�t�[,&��.p��������b�58Ec"{;v��p�g�X�mFgӍٽ��V�f����ml22:O.2-p���E�ǲ+
�����ߚP�����Q�����C��I���ךP-�� 8j@��2��R��W	`��a�濡������a���$�����
����P9��|	. *@����K�P�W����_�����z��O��q�U�������C�~������������(�?���?�_����c�p[�������?��]j���������?�d��%@��!�F �����̓�_`�����Q5������!��@��?@�ÿz�㇀��#�_����?��P����	�g�?��+B�k!5 ���Y��� � �� �����j�Q#��������ڀ�C8D�@����@C�C%����������� �� ���$���� ����������_���H�?��W����0���0���.�H�?��#@�U��*��tA�_�����
�O}�^���J�OW1��s<�x
���C:�C�&��J,?����'x���}��i��_�Q��_(�?�P�ׄ?����6�V@�����ow���O�����XV��Z��Iz�4�d���G�ML"�=^�O���P���q1MY����[�9�wU�|�k�#z#��F�=Z�k�\��:b�Q�l'��o�4=:}2"�Pl*���S:m"�X�����{xRu�����?�և����5t}k
������?����\���_��(�?���g���2�s��w�Vc�gءћGrg9�����_����p3u����hu����,�t����B�%�b�'3����љ8��]ӝ�`?l��ivn����P}�̚Q�S�vTv��`�2&��
4��翃�[������W|m�@a�����������?����@�$����������xK��_��ڟ���MG�<���֞X���K�U������l����n�N�<�kY�z��o������_eN�l(���ci�3͂�46S��8�:�,���h��1�sz���X_�K�,�nN�yIz1��%=�;�������8��J�2�^.�|���ܖT�����b�%]�w�R4�7���/v�q<���i$)O��}7��M��<fN����M����e�P4TK�:�9pw�b,.$L&��3��7O#ls�}<
�vo��b"i�Ɍ"�B�O5b�և�L�4�:�wԪ9�f������
� ���Y���������/Α���q��>����?u�#\�*�B�G�O�?a��|���%�F��E������	��
���$N<�i��*P���zB�z����1������q���
�����,��˗��<m�l;I��ARo��)�W����h)�}���ɯ��i�~uܔ돺�J��{��0�ŋ函�܏��}���B�?�|���֥oH�ݺެ˛syK-��[2vDG��ON�&}q]I*nuvwKY�(�嬑�k{�bF_�7��W��*S�\��I��Y��j�p2�_��=5��t�&�v�t�hS�?��/�����#�_[��������{;w}���O��ע"������!��4���L��D�%��M�Ր�ݶ,������f�bˈ<��[���q�r�c�#*�*&��%6/1�e��|$��h,z�8��x�`��d""��K�����>O�	
Cb���=�����y�X��ʺ�����H�?�a��������ܜ'h��TH�ׇi6�8M�$;��M	s��6dB<
��f�G���q����`��������b�;�A�S��~:
;y���0�|F.<)�4��(W��V��ȕ�Z���o�G�o��;�?A��WP�G=�?��*A�p�F��M��}��cA�U����^y���/��v�O}'O��4��*7���y����N��_X�>ԩ����6�}�����#����þ����{���w��n�a���YTr�;�T�wde��P�A�ZZ����I�	��op-�v�x��YQ�Q�g��p�h1���r�iu�D˺��퇽����~����r�Hb3NDw�nȣ��v���|Q�-;]�Em�*E{����$���v@8w��M8z5�_K�g���oVnb���A�ṥ̉�B�Fz5�Ӷ7֖]�j��n�/�X����(�?�����V�
���φt�<O�Ԝ'�[�/d�_1\̓��	��y��7�U�x�!}�`���@���������G�|�A�}<~���갛�MDF��;灃�u��ƙ�{\)��*ZgV;�'���e�M�`�-��}+>���}���Q8�U �wU{���W������_8�I �������U*���h!�����?�C�ϑP�W���?�-�!�|��5�65��XƱ�S�^?����c�C���\C������}l���~1��s�H�'��R�2��K�b*���N��i��)�+FK�w�\a�m]�;W��ѕ��o�ܟ�Ķ=�;7'u���t󐇞:�U��`�~{�V  > E����B۝t�3�̤�L\�������k����������am��׻���^��:'�xZΣ��:���֝�=����5�U���7[Da5v�C��j�
���3�ŽͬL����*�-9�rE�Zןn[�f5�R���B|^��z^�Qj
B�8��,E�+�`�7�&����ص�ao��]�/�[R�����p��lIV�����{]e!4�]Ø�:�<�j}��~U��{��o���Y�z���ve���l����Ty�2�cU���RI��R��J��g.��Ƀ�G][��2!�������+��߶������Б��C h�ȅ���!�; ��?!��?a�쿷��s�a �����_���ё��C!�������[��0��	P��A�7������{������~�,�������lȅ���ߡ�gFd��a��#�����%��3���エ� ��G��4u��?eJ������G��̕�_(��,ȉ�C]Dd���W��!��C6@��� �n�\���_�����$����۶�r��ŋ���y��AG.������C��L��P��?@����/k��B���۶�r��0�����?ԅ@D.��������&@��� ������+�`�'P��cC�?b���m�/��\�� �_�����T�����d@�?��C������`�(���y#/0��G���m��A��ԅ��?dD.���h�2I���Y�(34��u�L��ais�XbM�/���p�e�e-��2&Y&�"Gr���nݟ�<�����!�?^����2J�"�Q�>��r]��BSl��q+��L9�]����q�.�d��cݮ�q��ɝ�E���j-Nc�~���Z�vĆ?��=�nJ���NW���n��Q�tA�K!1��C��F+�%�s�!���T��f��۱kՈ�\Q��ŉ�o}�.I�Qi��Y�U糿wqQ�<g������@��Gk���y����CG��ЁR��x����[�vɃ���������ݤ�]�ס��D$��o�a�e��i[�wQm����g��Q���V{���F���mm��&�K;,�p�_K��vǷ�E��6��\���<F�j�]�cW��+9��)�N����k�G�_��_D�����~�F����/��B�A��A������h�l@����c��/��_|��ߣ���l��[v������U9rU���Og�զ?���|��&�d��W�Wv�8�z�{9�&�� 6�޸˒$��Ϣ�nQ�{cM�ۺ;)�%�>�+�|HZs�T��rb�y�ɦ� ��m���_ԺڮR
���VK�"n�s������WYü�0������k�Ѯ�ĮQyLS�������"<ڂ�s�'F_���ܬ���_i�4��6���|5��
�p:��m�RTW6jͽU�5�]�a��L��� ��RT�0�V:�0�����o���1��;p\�6dRk���k��6�K�`�Q,�B�[��O;@�GN������y%��,B�G�B��+�_<�d��O/^���>=�������&/��gA�� ���I`�����G��ԕ������bp�mq�����#��J���fB���@fOV����S��?�����������2��_& ��`H�����_.��@Fn��DB.��2�����L�f��)���>�(Qi������V��M��e\�h�l�?���}�����܏4��c����܏�ð?����~`����4��s�o�9��yx{]�o��D�zW<Q�:��$N-T��Y[v�2�a��Ƽ��Z����z�ِ���X� mt�}9�3FK��4��T�Q|u���b4��9����������v��%�Q��#M���b��i��-Ƃ2]��v=�Wp&�qՙ�:5X7�E�	Ϭ&mI��$��p���H����k���"�k.��Y��݇��T�P��>~����\�0����ߋE�Q��-��m�����GF����%�dJ.��+��(�����������B��30������E�Q7�M��m�����GD����0 �������d|���T�������k��0p\�4R[��9�T��5����Ǳl?O��Ʀ�66��s���� `O�|�(��m��?L�mh��QR*�Ap�������7mڢ7K�/�͐��h�Q���E�8Z�Q;ԋ\��J}cYVȇ��9 X��gr �4	��r z���7օE��]J��h9_�2��|ˏB������ړe�+)"�7-�?T�I9��ה�� qH�:�tkBu[��pz7������������ߧE�Q��m��m�y��"u��c�?��L����[�Z����"��K��S,m�4Y*�,eX�Ɠ����sf���s������3�����'��gÏ\�s����ø%�a:��6��Ӏji�r�뇓Y��Z��9�ʅ��?���7����.~�U��n�'"�٫��W�/|��i��~�r��C��aG���\=��ubO��\� ;�M`��ג����i��.��n�<�����#��?�@��O� &n ꦸI������G��x�/�5�#�"1'�
�b��Rl���CTk��)ዱu���ח��v8�Ҿ�W����eքS�1��ѱ_��8��:= �ǖ{�_5�����S=���B���ס59���k�G������Y���74X !�����/d@��A�����(��DC�?�-����o�����������𹱻�X] ��h�%݋�����#��?��=/�2���Ý��r�VӺ����j�a�\�4�X-j�ܢ󩌭��������q�I0Xl�m�PZ'V{h~��u�4+��mq�����K3K�<Q�z����Ui�SQ��B��	����ĸ)}�/�]K0)�NΟ���T��h����"�āl[^1
'�ʻ�HƘz~sO����ArӬfum8없�T�ڶ�l/b_i*��J�zj�l��!�#��.�%��CḶgǖ5��X������Xc�
�r�����x_m�hu�7�3�;N�U��ɿ����������w�z~^�gC�I&�����Iw�πswn�.��3-2���������Q�$�z� �k��S��RM����;�
v�/:�����r�&.=�9��� ':!~��"�k�X����;���^O7��������PR`&�������A���;~�T���O���Ƽ��O������>\|�g|c��ⸯ�?h�O�?��{��_����^=8�a��A�����q#\[��'f������3��{*fd���1r�W��Ą�T�🝫m9��'=�h:-L����o���^p�*J�û����9��H6<����_D�_��o{R������������y�*9*���_�����ӎ�?�}�?>OT$��6�κܟ�r���f��-v�av>~7O�>֒v�� �}3X�s����G��t%�9��%���sӇx�H�/ع����:����w�O�	Ý�)����|(�j{8�������6��f�˵}�µi���59������'�<_sr������^`S/���??��C�y����$K&��0��M��A,>7��3\��dU�q딒q�_\�]r�I�^�c�Z�}l�;R�US��N��$��]���y�¯?)��ݫf������?u��}~O���d                           \��6K& � 