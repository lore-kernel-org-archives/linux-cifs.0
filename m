From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] cifs: fix unaligned access in check2ndT2 and coalesce_t2
Date: Wed, 19 Jan 2011 09:42:19 -0600
Message-ID: <AANLkTi=ppdN00nu3UwSQTrxHvUZVssO4u0Fy06vnypgh@mail.gmail.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 18, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 33 ++++++++++++++-------------------
> =A01 files changed, 14 insertions(+), 19 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 9bcdf2b..d5b779e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -232,9 +232,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSiz=
e)
> =A0{
> =A0 =A0 =A0 =A0struct smb_t2_rsp *pSMBt;
> - =A0 =A0 =A0 int total_data_size;
> - =A0 =A0 =A0 int data_in_this_rsp;
> =A0 =A0 =A0 =A0int remaining;
> + =A0 =A0 =A0 __u16 total_data_size, data_in_this_rsp;
>
> =A0 =A0 =A0 =A0if (pSMB->Command !=3D SMB_COM_TRANSACTION2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> @@ -248,8 +247,8 @@ static int check2ndT2(struct smb_hdr *pSMB, unsig=
ned int maxBufSize)
>
> =A0 =A0 =A0 =A0pSMBt =3D (struct smb_t2_rsp *)pSMB;
>
> - =A0 =A0 =A0 total_data_size =3D le16_to_cpu(pSMBt->t2_rsp.TotalData=
Count);
> - =A0 =A0 =A0 data_in_this_rsp =3D le16_to_cpu(pSMBt->t2_rsp.DataCoun=
t);
> + =A0 =A0 =A0 total_data_size =3D get_unaligned_le16(&pSMBt->t2_rsp.T=
otalDataCount);
> + =A0 =A0 =A0 data_in_this_rsp =3D get_unaligned_le16(&pSMBt->t2_rsp.=
DataCount);
>
> =A0 =A0 =A0 =A0remaining =3D total_data_size - data_in_this_rsp;
>
> @@ -275,21 +274,18 @@ static int coalesce_t2(struct smb_hdr *psecond,=
 struct smb_hdr *pTargetSMB)
> =A0{
> =A0 =A0 =A0 =A0struct smb_t2_rsp *pSMB2 =3D (struct smb_t2_rsp *)psec=
ond;
> =A0 =A0 =A0 =A0struct smb_t2_rsp *pSMBt =A0=3D (struct smb_t2_rsp *)p=
TargetSMB;
> - =A0 =A0 =A0 int total_data_size;
> - =A0 =A0 =A0 int total_in_buf;
> - =A0 =A0 =A0 int remaining;
> - =A0 =A0 =A0 int total_in_buf2;
> =A0 =A0 =A0 =A0char *data_area_of_target;
> =A0 =A0 =A0 =A0char *data_area_of_buf2;
> - =A0 =A0 =A0 __u16 byte_count;
> + =A0 =A0 =A0 int remaining;
> + =A0 =A0 =A0 __u16 byte_count, total_data_size, total_in_buf, total_=
in_buf2;
>
> - =A0 =A0 =A0 total_data_size =3D le16_to_cpu(pSMBt->t2_rsp.TotalData=
Count);
> + =A0 =A0 =A0 total_data_size =3D get_unaligned_le16(&pSMBt->t2_rsp.T=
otalDataCount);
>
> - =A0 =A0 =A0 if (total_data_size !=3D le16_to_cpu(pSMB2->t2_rsp.Tota=
lDataCount)) {
> + =A0 =A0 =A0 if (total_data_size !=3D
> + =A0 =A0 =A0 =A0 =A0 get_unaligned_le16(&pSMB2->t2_rsp.TotalDataCoun=
t))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "total data size of primary an=
d secondary t2 differ");
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 total_in_buf =3D le16_to_cpu(pSMBt->t2_rsp.DataCount);
> + =A0 =A0 =A0 total_in_buf =3D get_unaligned_le16(&pSMBt->t2_rsp.Data=
Count);
>
> =A0 =A0 =A0 =A0remaining =3D total_data_size - total_in_buf;
>
> @@ -299,25 +295,25 @@ static int coalesce_t2(struct smb_hdr *psecond,=
 struct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0if (remaining =3D=3D 0) /* nothing to do, ignore */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> - =A0 =A0 =A0 total_in_buf2 =3D le16_to_cpu(pSMB2->t2_rsp.DataCount);
> + =A0 =A0 =A0 total_in_buf2 =3D get_unaligned_le16(&pSMB2->t2_rsp.Dat=
aCount);
> =A0 =A0 =A0 =A0if (remaining < total_in_buf2) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "transact2 2nd response contai=
ns too much data");
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* find end of first SMB data area */
> =A0 =A0 =A0 =A0data_area_of_target =3D (char *)&pSMBt->hdr.Protocol +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to=
_cpu(pSMBt->t2_rsp.DataOffset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_una=
ligned_le16(&pSMBt->t2_rsp.DataOffset);
> =A0 =A0 =A0 =A0/* validate target area */
>
> - =A0 =A0 =A0 data_area_of_buf2 =3D (char *) &pSMB2->hdr.Protocol +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le16_to_cpu(pSMB2->t2_rsp.DataOffset);
> + =A0 =A0 =A0 data_area_of_buf2 =3D (char *)&pSMB2->hdr.Protocol +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_una=
ligned_le16(&pSMB2->t2_rsp.DataOffset);
>
> =A0 =A0 =A0 =A0data_area_of_target +=3D total_in_buf;
>
> =A0 =A0 =A0 =A0/* copy second buffer into end of first buffer */
> =A0 =A0 =A0 =A0memcpy(data_area_of_target, data_area_of_buf2, total_i=
n_buf2);
> =A0 =A0 =A0 =A0total_in_buf +=3D total_in_buf2;
> - =A0 =A0 =A0 pSMBt->t2_rsp.DataCount =3D cpu_to_le16(total_in_buf);
> + =A0 =A0 =A0 put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCou=
nt);
> =A0 =A0 =A0 =A0byte_count =3D get_bcc_le(pTargetSMB);
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> =A0 =A0 =A0 =A0put_bcc_le(byte_count, pTargetSMB);
> @@ -334,7 +330,6 @@ static int coalesce_t2(struct smb_hdr *psecond, s=
truct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0; /* we are done */
> =A0 =A0 =A0 =A0} else /* more responses to go */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> -
> =A0}
>
> =A0static void
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct.
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
