From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix extended security auth failure
Date: Fri, 8 Apr 2011 08:49:47 -0500
Message-ID: <BANLkTik=Mgbbu7G0U6oPvELEktCFQTArDg@mail.gmail.com>
References: <1302097566-11576-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110408094028.61a2f507@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110408094028.61a2f507-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 8, 2011 at 8:40 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> w=
rote:
> On Wed, =A06 Apr 2011 08:46:06 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Fix authentication failures using extended security mechanisms.
>> cifs client does not take into consideration extended security bit
>> in capabilities field in negotiate protocol response from the server=
=2E
>>
>> Please refer to Samba bugzilla 8046.
>>
>>
>> Reported-and-tested by: Werner Maes <Werner.Maes-UiU5zyVfpuo0a//2gYcwQw@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifssmb.c | =A0 17 ++++++-----------
>> =A01 files changed, 6 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 3291770..e119d70 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -570,18 +570,10 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
_ses *ses)
>> =A0 =A0 =A0 if (pSMBr->EncryptionKeyLength =3D=3D CIFS_CRYPTO_KEY_SI=
ZE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->cryptkey, pSMBr->u.E=
ncryptionKey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_CRYPTO_KEY_SIZE);
>> - =A0 =A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (pSMBr->EncryptionKeyLe=
ngth =3D=3D 0)) {
>> + =A0 =A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities & CAP=
_EXTENDED_SECURITY) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (pSMBr->En=
cryptionKeyLength =3D=3D 0)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* decode security blob */
>
> This looks wrong to me. CAP_EXTENDED_SECURITY just means that the
> server supports extended security, not that it's in use, right? Aren'=
t
> we just working around server brokenness here. Why isn't it setting
> SMBFLG2_EXT_SEC if it's using extended security?
>
> Are there cases where the server might set EncryptionKeyLength to 0,
> and *not* be using extended security? If not, then why bother to chec=
k
> the flags or capabilities at all?
>
>> - =A0 =A0 } else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* no crypt key only if plain=
 text pwd */
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* BB might be helpful to save off the domain of server he=
re */
>> -
>> - =A0 =A0 if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 (server->capabilities & CAP_EXTENDED_SECUR=
ITY)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D get_bcc(&pSMBr->hdr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (count < 16) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
>> @@ -624,6 +616,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_s=
es *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -EOPNOTSUPP;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* no crypt key only if plain=
 text pwd */
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
>> =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities &=3D ~CAP_EXTENDED_=
SECURITY;
>>
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>

I checked in ms-cifs and ms-smb, and there is no mention of server need=
ing
to set extended security bit in flags2 in smb header but ms-smb does me=
ntion
about server setting extended security bit in capabilities field in
negotiate protocol response (there is an example of the exchange in ms-=
smb).
When server is indicating it supports extended security, it should set
encryptionkeylength to 0 since the ensuing exchange will involve an
encryption key (challenge).
