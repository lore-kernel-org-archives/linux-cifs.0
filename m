From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove unused CIFSSMBNotify
Date: Wed, 1 Dec 2010 07:55:54 -0600
Message-ID: <AANLkTimqQSDWs9kCmXpuWGQTLkwBbM1WA-XTsPgH5G8R@mail.gmail.com>
References: <1290457863-10804-1-git-send-email-jlayton@redhat.com>
	<1290457863-10804-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290457863-10804-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 22, 2010 at 2:31 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> =
wrote:
> ...and the global variables that only it references.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A04 ---
> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 ---
> =A0fs/cifs/cifsproto.h | =A0 =A04 ---
> =A0fs/cifs/cifssmb.c =A0 | =A0 73 -----------------------------------=
----------------
> =A04 files changed, 0 insertions(+), 86 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 0ab2e2f..041d7c3 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -911,10 +911,6 @@ init_cifs(void)
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0cifs_proc_init();
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&cifs_tcp_ses_list);
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> - =A0 =A0 =A0 INIT_LIST_HEAD(&GlobalDnotifyReqList);
> - =A0 =A0 =A0 INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
> -#endif
> =A0/*
> =A0* =A0Initialize Global counters
> =A0*/
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index bba731c..b4c2524 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -735,11 +735,6 @@ GLOBAL_EXTERN spinlock_t =A0 =A0 =A0 =A0 =A0 cif=
s_tcp_ses_lock;
> =A0*/
> =A0GLOBAL_EXTERN spinlock_t =A0 =A0 =A0 cifs_file_list_lock;
>
> -/* Outstanding dir notify requests */
> -GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
> -/* DirNotify response queue */
> -GLOBAL_EXTERN struct list_head GlobalDnotifyRsp_Q;
> -
> =A0/*
> =A0* Global transaction id (XID) information
> =A0*/
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 6ed59af..7b0ca3a 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -383,10 +383,6 @@ extern int CIFSSMBCopy(int xid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *toName, co=
nst int flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table=
 *nls_codepage,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int remap_special_char=
s);
> -extern int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int notify_subdir=
s, const __u16 netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 filter, struct fi=
le *file, int multishot,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table =
*nls_codepage);
> =A0extern ssize_t CIFSSMBQAllEAs(const int xid, struct cifsTconInfo *=
tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *s=
earchName,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *e=
a_name, char *EAData,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 2f2632b..0ef7c3a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -5381,79 +5381,6 @@ setPermsRetry:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int notify_subdirs, const __u=
16 netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 filter, struct file *pfile, i=
nt multishot,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_codepag=
e)
> -{
> - =A0 =A0 =A0 int rc =3D 0;
> - =A0 =A0 =A0 struct smb_com_transaction_change_notify_req *pSMB =3D =
NULL;
> - =A0 =A0 =A0 struct smb_com_ntransaction_change_notify_rsp *pSMBr =3D=
 NULL;
> - =A0 =A0 =A0 struct dir_notify_req *dnotify_req;
> - =A0 =A0 =A0 int bytes_returned;
> -
> - =A0 =A0 =A0 cFYI(1, "In CIFSSMBNotify for file handle %d", (int)net=
fid);
> - =A0 =A0 =A0 rc =3D smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **=
) &pSMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void **) &pSMBr);
> - =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> -
> - =A0 =A0 =A0 pSMB->TotalParameterCount =3D 0 ;
> - =A0 =A0 =A0 pSMB->TotalDataCount =3D 0;
> - =A0 =A0 =A0 pSMB->MaxParameterCount =3D cpu_to_le32(2);
> - =A0 =A0 =A0 /* BB find exact data count max from sess structure BB =
*/
> - =A0 =A0 =A0 pSMB->MaxDataCount =3D 0; /* same in little endian or b=
e */
> -/* BB VERIFY verify which is correct for above BB */
> - =A0 =A0 =A0 pSMB->MaxDataCount =3D cpu_to_le32((tcon->ses->server->=
maxBuf -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
> -
> - =A0 =A0 =A0 pSMB->MaxSetupCount =3D 4;
> - =A0 =A0 =A0 pSMB->Reserved =3D 0;
> - =A0 =A0 =A0 pSMB->ParameterOffset =3D 0;
> - =A0 =A0 =A0 pSMB->DataCount =3D 0;
> - =A0 =A0 =A0 pSMB->DataOffset =3D 0;
> - =A0 =A0 =A0 pSMB->SetupCount =3D 4; /* single byte does not need le=
 conversion */
> - =A0 =A0 =A0 pSMB->SubCommand =3D cpu_to_le16(NT_TRANSACT_NOTIFY_CHA=
NGE);
> - =A0 =A0 =A0 pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> - =A0 =A0 =A0 if (notify_subdirs)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->WatchTree =3D 1; /* one byte - no=
 le conversion needed */
> - =A0 =A0 =A0 pSMB->Reserved2 =3D 0;
> - =A0 =A0 =A0 pSMB->CompletionFilter =3D cpu_to_le32(filter);
> - =A0 =A0 =A0 pSMB->Fid =3D netfid; /* file handle always le */
> - =A0 =A0 =A0 pSMB->ByteCount =3D 0;
> -
> - =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) p=
SMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *)pS=
MBr, &bytes_returned,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_ASYNC_OP);
> - =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Notify =3D %d", rc);
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Add file to outstanding requests */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB change to kmem cache alloc */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req =3D kmalloc(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct dir_notify_req),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dnotify_req) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->Pid =3D pS=
MB->hdr.Pid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->PidHigh =3D=
 pSMB->hdr.PidHigh;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->Mid =3D pS=
MB->hdr.Mid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->Tid =3D pS=
MB->hdr.Tid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->Uid =3D pS=
MB->hdr.Uid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->netfid =3D=
 netfid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->pfile =3D =
pfile;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->filter =3D=
 filter;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dnotify_req->multishot =
=3D multishot;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lo=
ck);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&dnotify_=
req->lhead,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &GlobalDnotifyReqList);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_=
Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 cifs_buf_release(pSMB);
> - =A0 =A0 =A0 return rc;
> -}
> -
> =A0#ifdef CONFIG_CIFS_XATTR
> =A0/*
> =A0* Do a path-based QUERY_ALL_EAS call and parse the result. This is=
 a common
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Do not think this function has been used for a long time.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
