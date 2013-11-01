From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH linux-next V2] cifs: Make big endian multiplex ID
 sequences monotonic on the wire
Date: Fri, 1 Nov 2013 13:50:59 -0500
Message-ID: <CAH2r5mt5kBDR1oZfDNVu+bd7-jf=zQ6tBm2YjKXKBwdYE+YG=w@mail.gmail.com>
References: <1381941162-72831-1-git-send-email-timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <sfrench@samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>
To: Tim Gardner <timg@tpi.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1381941162-72831-1-git-send-email-timg@tpi.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

This has a couple of obvious endian errors.  I will correct your patch
and remerge into cifs-2.6.git for-next

Please always remember to run endian checks against cifs builds when
submitting a patch (and make sure sparse is installed)

e.g.

make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bc7c978..1a1fdcc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -630,7 +630,7 @@ get_next_mid64(struct TCP_Server_Info *server)
     return server->ops->get_next_mid(server);
 }

-static inline __u16
+static inline __le16
 get_next_mid(struct TCP_Server_Info *server)
 {
     __u16 mid = get_next_mid64(server);
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index f9bb497..9e5ee34 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -428,7 +428,7 @@ struct smb_hdr {
     __u16 Tid;
     __le16 Pid;
     __u16 Uid;
-    __u16 Mid;
+    __le16 Mid;
     __u8 WordCount;
 } __attribute__((packed));

On Wed, Oct 16, 2013 at 11:32 AM, Tim Gardner <timg@tpi.com> wrote:
> The multiplex identifier (MID) in the SMB header is only
> ever used by the client, in conjunction with PID, to match responses
> from the server. As such, the endianess of the MID is not important.
> However, When tracing packet sequences on the wire, protocol analyzers
> such as wireshark display MID as little endian. It is much more informative
> for the on-the-wire MID sequences to match debug information emitted by the
> CIFS driver.  Therefore, one should write and read MID in the SMB header
> assuming it is always little endian.
>
> Observed from wireshark during the protocol negotiation
> and session setup:
>
>         Multiplex ID: 256
>         Multiplex ID: 256
>         Multiplex ID: 512
>         Multiplex ID: 512
>         Multiplex ID: 768
>         Multiplex ID: 768
>
> After this patch on-the-wire MID values begin at 1 and increase monotonically.
>
> Introduce get_next_mid64() for the internal consumers that use the full 64 bit
> multiplex identifier.
>
> Introduce the helpers get_mid() and compare_mid() to make the endian
> translation clear.
>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Steve French <sfrench@samba.org>
> Signed-off-by: Tim Gardner <timg@tpi.com>
> ---
>
> V2 - get an endian appropriate copy of 'mid' for debug output in checkSMB().
>      Actually use the new helper get_mid() wherever smb->Mid is referenced.
>
>  fs/cifs/cifsglob.h      |   25 ++++++++++++++++++++++++-
>  fs/cifs/misc.c          |   10 ++++++----
>  fs/cifs/smb1ops.c       |    4 ++--
>  fs/cifs/smb2transport.c |    2 +-
>  fs/cifs/transport.c     |    2 +-
>  5 files changed, 34 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 52b6f6c..535e324 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -620,11 +620,34 @@ set_credits(struct TCP_Server_Info *server, const int val)
>  }
>
>  static inline __u64
> -get_next_mid(struct TCP_Server_Info *server)
> +get_next_mid64(struct TCP_Server_Info *server)
>  {
>         return server->ops->get_next_mid(server);
>  }
>
> +static inline __u16
> +get_next_mid(struct TCP_Server_Info *server)
> +{
> +       __u16 mid = get_next_mid64(server);
> +       /*
> +        * The value in the SMB header should be little endian for easy
> +        * on-the-wire decoding.
> +        */
> +       return cpu_to_le16(mid);
> +}
> +
> +static inline __u16
> +get_mid(const struct smb_hdr *smb)
> +{
> +       return le16_to_cpu(smb->Mid);
> +}
> +
> +static inline bool
> +compare_mid(__u16 mid, const struct smb_hdr *smb)
> +{
> +       return mid == le16_to_cpu(smb->Mid);
> +}
> +
>  /*
>   * When the server supports very large reads and writes via POSIX extensions,
>   * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X header, not
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 298e31e..2f9f379 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -295,7 +295,8 @@ check_smb_hdr(struct smb_hdr *smb)
>         if (smb->Command == SMB_COM_LOCKING_ANDX)
>                 return 0;
>
> -       cifs_dbg(VFS, "Server sent request, not response. mid=%u\n", smb->Mid);
> +       cifs_dbg(VFS, "Server sent request, not response. mid=%u\n",
> +                get_mid(smb));
>         return 1;
>  }
>
> @@ -351,6 +352,7 @@ checkSMB(char *buf, unsigned int total_read)
>         }
>
>         if (4 + rfclen != clc_len) {
> +               __u16 mid = get_mid(smb);
>                 /* check if bcc wrapped around for large read responses */
>                 if ((rfclen > 64 * 1024) && (rfclen > clc_len)) {
>                         /* check if lengths match mod 64K */
> @@ -358,11 +360,11 @@ checkSMB(char *buf, unsigned int total_read)
>                                 return 0; /* bcc wrapped */
>                 }
>                 cifs_dbg(FYI, "Calculated size %u vs length %u mismatch for mid=%u\n",
> -                        clc_len, 4 + rfclen, smb->Mid);
> +                        clc_len, 4 + rfclen, mid);
>
>                 if (4 + rfclen < clc_len) {
>                         cifs_dbg(VFS, "RFC1001 size %u smaller than SMB for mid=%u\n",
> -                                rfclen, smb->Mid);
> +                                rfclen, mid);
>                         return -EIO;
>                 } else if (rfclen > clc_len + 512) {
>                         /*
> @@ -375,7 +377,7 @@ checkSMB(char *buf, unsigned int total_read)
>                          * data to 512 bytes.
>                          */
>                         cifs_dbg(VFS, "RFC1001 size %u more than 512 bytes larger than SMB for mid=%u\n",
> -                                rfclen, smb->Mid);
> +                                rfclen, mid);
>                         return -EIO;
>                 }
>         }
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 8233b17..09ef8f3 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -67,7 +67,7 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
>         mutex_unlock(&server->srv_mutex);
>
>         cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc = %d\n",
> -                in_buf->Mid, rc);
> +                get_mid(in_buf), rc);
>
>         return rc;
>  }
> @@ -101,7 +101,7 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
>
>         spin_lock(&GlobalMid_Lock);
>         list_for_each_entry(mid, &server->pending_mid_q, qhead) {
> -               if (mid->mid == buf->Mid &&
> +               if (compare_mid(mid->mid, buf) &&
>                     mid->mid_state == MID_REQUEST_SUBMITTED &&
>                     le16_to_cpu(mid->command) == buf->Command) {
>                         spin_unlock(&GlobalMid_Lock);
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 340abca..c523617 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -466,7 +466,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  static inline void
>  smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct smb2_hdr *hdr)
>  {
> -       hdr->MessageId = get_next_mid(server);
> +       hdr->MessageId = get_next_mid64(server);
>  }
>
>  static struct mid_q_entry *
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 6fdcb1b..057b2c0 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -58,7 +58,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
>                 return temp;
>         else {
>                 memset(temp, 0, sizeof(struct mid_q_entry));
> -               temp->mid = smb_buffer->Mid;    /* always LE */
> +               temp->mid = get_mid(smb_buffer);
>                 temp->pid = current->pid;
>                 temp->command = cpu_to_le16(smb_buffer->Command);
>                 cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
> --
> 1.7.9.5
>



-- 
Thanks,

Steve
