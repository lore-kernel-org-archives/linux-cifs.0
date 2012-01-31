From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] cifs: fix printk format warnings
Date: Tue, 31 Jan 2012 07:43:37 -0600
Message-ID: <CAH2r5mu2VXWkP49RzPuedN9hY6G-WcbyYB3WMJSf2NkRe2VO7Q@mail.gmail.com>
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
	<4F2764E9.4010506@xenotime.net>
	<20120131054231.66669e41@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120131054231.66669e41-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged to cifs-2.6.git

On Tue, Jan 31, 2012 at 4:42 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 30 Jan 2012 19:50:01 -0800
> Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org> wrote:
>
>> From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
>>
>> Fix printk format warnings for ssize_t variables:
>>
>> fs/cifs/connect.c:2145:3: warning: format '%ld' expects type 'long i=
nt', but argument 3 has type 'ssize_t'
>> fs/cifs/connect.c:2152:3: warning: format '%ld' expects type 'long i=
nt', but argument 3 has type 'ssize_t'
>> fs/cifs/connect.c:2160:3: warning: format '%ld' expects type 'long i=
nt', but argument 3 has type 'ssize_t'
>> fs/cifs/connect.c:2170:3: warning: format '%ld' expects type 'long i=
nt', but argument 3 has type 'ssize_t'
>>
>> Signed-off-by: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
>> Cc: =A0 Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> Cc: =A0 linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>> =A0fs/cifs/connect.c | =A0 =A08 ++++----
>> =A01 file changed, 4 insertions(+), 4 deletions(-)
>>
>> --- linux-next-20120130.orig/fs/cifs/connect.c
>> +++ linux-next-20120130/fs/cifs/connect.c
>> @@ -2142,14 +2142,14 @@ cifs_set_cifscreds(struct smb_vol *vol,
>>
>> =A0 =A0 =A0 len =3D delim - payload;
>> =A0 =A0 =A0 if (len > MAX_USERNAME_SIZE || len <=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad value from username search (l=
en=3D%ld)", len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad value from username search (l=
en=3D%zd)", len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 vol->username =3D kstrndup(payload, len, GFP_KERNEL);
>> =A0 =A0 =A0 if (!vol->username) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to allocate %ld bytes for =
username", len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to allocate %zd bytes for =
username", len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
>> =A0 =A0 =A0 }
>> @@ -2157,7 +2157,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
>>
>> =A0 =A0 =A0 len =3D key->datalen - (len + 1);
>> =A0 =A0 =A0 if (len > MAX_PASSWORD_SIZE || len <=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad len for password search (len=3D=
%ld)", len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad len for password search (len=3D=
%zd)", len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(vol->username);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->username =3D NULL;
>> @@ -2167,7 +2167,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
>> =A0 =A0 =A0 ++delim;
>> =A0 =A0 =A0 vol->password =3D kstrndup(delim, len, GFP_KERNEL);
>> =A0 =A0 =A0 if (!vol->password) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to allocate %ld bytes for =
password", len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to allocate %zd bytes for =
password", len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(vol->username);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->username =3D NULL;
>
> Looks correct.
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
