From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/7 cifs] ntlm authentication and signing - Correct
 response length for ntlmv2 authentication without extended security
Date: Mon, 4 Oct 2010 07:56:59 -0500
Message-ID: <AANLkTi=AcTkDTxECT=y-3uJWMjG7B1edysyVPxm2O_fk@mail.gmail.com>
References: <1285771128-23075-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101004064130.04e0d1bb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101004064130.04e0d1bb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 4, 2010 at 5:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 29 Sep 2010 09:38:48 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Fix incorrect calculation of case sensitive response length in the
>> ntlmv2 (without extended security) response.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/sess.c | =A0 11 +++++++----
>> =A01 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index af18a50..9148fd8 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -739,9 +739,6 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.CaseInsensitivePassw=
ordLength =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* =A0 =A0 =A0cpu_to_le16(LM2_SESS_KEY_S=
IZE); */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.CaseSensitivePasswordL=
ength =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(struct =
ntlmv2_resp));
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_key=
, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> @@ -756,11 +753,17 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->tilen > 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->tib=
lob, ses->tilen);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->tilen;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.CaseSe=
nsitivePasswordLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le1=
6(sizeof(struct ntlmv2_resp) +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 ses->tilen);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we never did allocate=
 ses->domainName to free */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->tiblob);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D NULL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.CaseSe=
nsitivePasswordLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le1=
6(sizeof(struct ntlmv2_resp));
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr=
 =3D 0;
>
> Looks reasonable, but I think it would be clearer to just have a sing=
le
> place that sets CaseSensitivePasswordLength. If ses->tilen > 0, then =
you
> add the tilen to it...but tilen will never be less than 0, so there's
> no need to have this inside that if block, right?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff,  yes, I can do that. Thanks.
