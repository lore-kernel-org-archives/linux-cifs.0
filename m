From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Move buffer allocation to a separate function
Date: Fri, 24 Jun 2011 11:36:55 +0400
Message-ID: <BANLkTim_601-1QEbASJ+-r8UR-W5fsk+ig@mail.gmail.com>
References: <1308898317-7667-1-git-send-email-piastryyy@gmail.com>
	<1308898317-7667-2-git-send-email-piastryyy@gmail.com>
	<20110624071159.GA11901@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110624071159.GA11901-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/24 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
> On Fri, Jun 24, 2011 at 10:51:53AM +0400, Pavel Shilovsky wrote:
>> +static bool
>> +allocate_buffers(char **pbigbuf, char **psmallbuf, unsigned int siz=
e,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0bool isLargeBuf)
>
> No p-prefixes for pointers, and no camelCase, please.
>
>> +{
>> + =A0 =A0 char *bigbuf =3D *pbigbuf, *smallbuf =3D *psmallbuf;
>> +
>> + =A0 =A0 if (bigbuf =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 bigbuf =3D (char *)cifs_buf_get();
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!bigbuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No memory for l=
arge SMB response");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(3000);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry will check if exi=
ting */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else if (isLargeBuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* we are reusing a dirty large buf, clear=
 its start */
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(bigbuf, 0, size);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (smallbuf =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 smallbuf =3D (char *)cifs_small_buf_get();
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!smallbuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No memory for S=
MB response");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(1000);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry will check if exi=
ting */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* beginning of smb buffer is cleared in o=
ur buf_get */
>> + =A0 =A0 } else /* if existing small buf clear beginning */
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(smallbuf, 0, size);
>> +
>> + =A0 =A0 *pbigbuf =3D bigbuf;
>> + =A0 =A0 *psmallbuf =3D smallbuf;
>> +
>> + =A0 =A0 return true;
>
> But in the end this whole code doesn't make any sense at all. =A0Just
> sleeping when failing to memory is a bad idea, as is all this partial
> reuse stuff.
>
> Someone needs to rearchitect this code to actually make sense.
>
>

Thanks for your comments! I think that moving this code to a separate
function is a good point to start with and further we can rethink it.

--=20
Best regards,
Pavel Shilovsky.
