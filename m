From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Revised patch to convert MessageID in smb2_hdr to LE
Date: Tue, 09 Dec 2014 17:35:39 +0000
Message-ID: <1418146539.7919.16.camel@redhat.com>
References: <CAH2r5msxSvtbCzPOnTpvzas5Qg46O-SJqc05GA1i2Ts74uYPtQ@mail.gmail.com>
	 <CAH2r5mtc0HzLKxOQBkn3-e3Xzw73cPFKa3QqZrrvCUxPOKH+kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtc0HzLKxOQBkn3-e3Xzw73cPFKa3QqZrrvCUxPOKH+kg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2014-12-08 at 16:46 -0600, Steve French wrote:
> Resending (attaching patch)
> 
> Redhat had encountered a problem with the SMB2/SMB3 message id (mid)
> on PPC - the message id was being considered opaque and endian neutral.
> Change the SMB2/SMB3 message id to be le64 on the wire (as we already
> do with cifs).
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello Steve,

The patch is very similar to the patch I've created. Testing took time
since I had to first provision a ppc64 machine and then recompile the
rawhide kernel for it since ppc64 isn't available in rawhide. 

I've documented the differences between my patch and the patch you
proposed inline.

> ---
>  fs/cifs/smb2misc.c      | 12 +++++++-----
>  fs/cifs/smb2ops.c       |  2 +-
>  fs/cifs/smb2pdu.h       |  2 +-
>  fs/cifs/smb2transport.c |  4 ++--
>  4 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 1a08a34..6e01933 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -32,12 +32,14 @@
>  static int
>  check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
>  {
> +    __u64 wire_mid = le64_to_cpu(hdr->MessageId);
> +
>      /*
>       * Make sure that this really is an SMB, that it is a response,
>       * and that the message ids match.
>       */
>      if ((*(__le32 *)hdr->ProtocolId == SMB2_PROTO_NUMBER) &&
> -        (mid == hdr->MessageId)) {
> +        (mid == wire_mid)) {
>          if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
>              return 0;
>          else {
> @@ -51,11 +53,11 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
>          if (*(__le32 *)hdr->ProtocolId != SMB2_PROTO_NUMBER)
>              cifs_dbg(VFS, "Bad protocol string signature header %x\n",
>                   *(unsigned int *) hdr->ProtocolId);
> -        if (mid != hdr->MessageId)
> +        if (mid != wire_mid)
>              cifs_dbg(VFS, "Mids do not match: %llu and %llu\n",
> -                 mid, hdr->MessageId);
> +                 mid, wire_mid);
>      }
> -    cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", hdr->MessageId);
> +    cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", wire_mid);
>      return 1;
>  }
> 
> @@ -95,7 +97,7 @@ smb2_check_message(char *buf, unsigned int length)
>  {
>      struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
>      struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
> -    __u64 mid = hdr->MessageId;
> +    __u64 mid = le64_to_cpu(hdr->MessageId);
>      __u32 len = get_rfc1002_length(buf);
>      __u32 clc_len;  /* calculated length */
>      int command;

My earlier version of the patch changed the type for the argument mid in
check_smb2_hdr() from __u64 to __le64 and changes were made accordingly.
Your version looks better. So I've used this in my patch too.

> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 568f323..e5b33d0 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -179,7 +179,7 @@ smb2_find_mid(struct TCP_Server_Info *server, char *buf)
> 
>      spin_lock(&GlobalMid_Lock);
>      list_for_each_entry(mid, &server->pending_mid_q, qhead) {
> -        if ((mid->mid == hdr->MessageId) &&
> +        if ((mid->mid == le64_to_cpu(hdr->MessageId)) &&

Don't know if this matters much but I've used a temp varialble which
holds the value for le64_to_cpu(hdr->MessageId) and uses that for
comparison in the loop instead.

>              (mid->mid_state == MID_REQUEST_SUBMITTED) &&
>              (mid->command == hdr->Command)) {
>              spin_unlock(&GlobalMid_Lock);
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index d84f46c..2d6d388 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -110,7 +110,7 @@ struct smb2_hdr {
>      __le16 CreditRequest;  /* CreditResponse */
>      __le32 Flags;
>      __le32 NextCommand;
> -    __u64  MessageId;    /* opaque - so can stay little endian */
> +    __le64  MessageId;    /* opaque - so can stay little endian */
I've removed the comment since it doesn't appear to be opaque.

>      __le32 ProcessId;
>      __u32  TreeId;        /* opaque - so do not make little endian */
>      __u64  SessionId;    /* opaque - so do not make little endian */
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 5111e72..6bdee1b5 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -468,7 +468,7 @@ smb2_seq_num_into_buf(struct TCP_Server_Info
> *server, struct smb2_hdr *hdr)
>  {
>      unsigned int i, num = le16_to_cpu(hdr->CreditCharge);
> 
> -    hdr->MessageId = get_next_mid64(server);
> +    hdr->MessageId = cpu_to_le64(get_next_mid64(server));

get_next_mid() already returns the MID in little endian form. To be
consistent, get_next_mid64() should also return the MID in little
endian.


>      /* skip message numbers according to CreditCharge field */
>      for (i = 1; i < num; i++)
>          get_next_mid(server);
> @@ -490,7 +490,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
>          return temp;
>      else {
>          memset(temp, 0, sizeof(struct mid_q_entry));
> -        temp->mid = smb_buffer->MessageId;    /* always LE */
> +        temp->mid = le64_to_cpu(smb_buffer->MessageId);
>          temp->pid = current->pid;
>          temp->command = smb_buffer->Command;    /* Always LE */
>          temp->when_alloc = jiffies;
> -- 
> 

I've also tested your version of the patch. The client was able to mount
and perform a few simple tasks as required.

The new version(v3) of the patch I had written was successfully tested
on a ppc64 machine. I will send my version (v3) of the patch to the
mailing-list.

Sachin Prabhu
