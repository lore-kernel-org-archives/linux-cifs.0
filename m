From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove unnecessary locking around sequence_number
Date: Wed, 1 Dec 2010 08:35:31 -0600
Message-ID: <AANLkTimn=L-9puM058T6mBwTtOhzRbK2SdqEXn2WQKYY@mail.gmail.com>
References: <1290457863-10804-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290457863-10804-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 22, 2010 at 2:31 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> =
wrote:
> The server->sequence_number is already protected by the srv_mutex. Th=
e
> GlobalMid_lock is unneeded here.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 =A06 ++----
> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +-
> =A02 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index f856732..66f3d50 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -72,6 +72,7 @@ static int cifs_calculate_signature(const struct sm=
b_hdr *cifs_pdu,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/* must be called with server->srv_mutex held */
> =A0int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info=
 *server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *pexpected_response_sequence=
_number)
> =A0{
> @@ -84,14 +85,12 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struc=
t TCP_Server_Info *server,
> =A0 =A0 =A0 =A0if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) =3D=
=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.SequenceNumber =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le32(server->se=
quence_number);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.Reserved =3D 0;
>
> =A0 =A0 =A0 =A0*pexpected_response_sequence_number =3D server->sequen=
ce_number++;
> =A0 =A0 =A0 =A0server->sequence_number++;
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0rc =3D cifs_calculate_signature(cifs_pdu, server, smb_=
signature);
> =A0 =A0 =A0 =A0if (rc)
> @@ -149,6 +148,7 @@ static int cifs_calc_signature2(const struct kvec=
 *iov, int n_vec,
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/* must be called with server->srv_mutex held */
> =A0int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_=
Info *server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *pexpected_response_sequenc=
e_number)
> =A0{
> @@ -162,14 +162,12 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec,=
 struct TCP_Server_Info *server,
> =A0 =A0 =A0 =A0if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) =3D=
=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.SequenceNumber =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to=
_le32(server->sequence_number);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.Reserved =3D 0;
>
> =A0 =A0 =A0 =A0*pexpected_response_sequence_number =3D server->sequen=
ce_number++;
> =A0 =A0 =A0 =A0server->sequence_number++;
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0rc =3D cifs_calc_signature2(iov, n_vec, server, smb_si=
gnature);
> =A0 =A0 =A0 =A0if (rc)
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a8d9f32..bba731c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -200,7 +200,7 @@ struct TCP_Server_Info {
> =A0 =A0 =A0 =A0char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, =
ntlmv2 etc */
> =A0 =A0 =A0 =A0/* 16th byte of RFC1001 workstation name is always nul=
l */
> =A0 =A0 =A0 =A0char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NU=
LL];
> - =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signature=
 */
> + =A0 =A0 =A0 __u32 sequence_number; /* for signing, protected by srv=
_mutex */
> =A0 =A0 =A0 =A0struct session_key session_key;
> =A0 =A0 =A0 =A0unsigned long lstrp; /* when we got last response from=
 this server */
> =A0 =A0 =A0 =A0u16 dialect; /* dialect index that server chose */
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct. Two less contenders for global mid lock.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
