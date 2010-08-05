From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 5/8] cifs: implement CIFSCheckMFSymlink()
Date: Thu, 05 Aug 2010 17:47:09 +0200
Message-ID: <4C5ADCFD.1010206@samba.org>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com> <1280931109-22380-6-git-send-email-metze@samba.org> <4C5AB228.90800@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3ACC019A6B27C063B54B83C7"
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5AB228.90800-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3ACC019A6B27C063B54B83C7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 05.08.2010 14:44, schrieb Suresh Jayaraman:
> On 08/04/2010 07:41 PM, Stefan Metzmacher wrote:
>> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>>  fs/cifs/link.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  1 files changed, 65 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
>> index 0d90a89..6cd0879 100644
>> --- a/fs/cifs/link.c
>> +++ b/fs/cifs/link.c
>> @@ -114,6 +114,71 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>>  		   const unsigned char *path,
>>  		   struct cifs_sb_info *cifs_sb, int xid)
>>  {
>> +	int rc;
>> +	int oplock =3D 0;
>> +	__u16 netfid =3D 0;
>> +	struct cifsTconInfo *pTcon =3D cifs_sb->tcon;
>> +	u8 *buf;
>> +	char *pbuf;
>> +	unsigned int bytes_read =3D 0;
>> +	int buf_type =3D CIFS_NO_BUFFER;
>> +	unsigned int link_len =3D 0;
>> +	FILE_ALL_INFO file_info;
>> +
>> +	if (!(fattr->cf_mode & S_IFREG))
>> +		/* it's not a symlink */
>> +		return 0;
>=20
> Perhaps a little naive - what if cf_mode is S_IFDIR?

Then it's a directory and not a symlink.

metze


--------------enig3ACC019A6B27C063B54B83C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkxa3P0ACgkQm70gjA5TCD8qZQCdGzdhmo9b6tasHQ1opDYzjVH+
Bp8An0UV2g/6IZNvifm/vGqcVkxztBdD
=jLdz
-----END PGP SIGNATURE-----

--------------enig3ACC019A6B27C063B54B83C7--
