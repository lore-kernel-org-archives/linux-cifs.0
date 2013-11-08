From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH linux-next] cifs: Use data structures to compute NTLMv2
 response offsets
Date: Fri, 8 Nov 2013 15:19:31 -0600
Message-ID: <CADT32e+ed9EzAb2jraHxmB0CF5AMUQ7XYiuEfH-FOcy7XqqmNQ@mail.gmail.com>
References: <1383867657-110399-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383867657-110399-1-git-send-email-tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.  You may want to verify that the code works fine for both
sec=ntlmssp/ntlmsspi and sec=ntlmv2/ntlmv2i mount options.

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Thu, Nov 7, 2013 at 5:40 PM, Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> A bit of cleanup plus some gratuitous variable renaming. I think using
> structures instead of numeric offsets makes this code much more
> understandable.
>
> Also added a comment about current time range expected by
> the server.
>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>
> The comment about time of day needing to be within 5 minutes is important (to me
> at least). I spent the best part of a week thinking I had endian issues on powerpc
> when in truth I was just too stupid to notice that the clock
> was not updated. Danged embedded platforms...
>
> checkpatch has some problems with this patch regarding attribute packed, but I chose
> to remain consistent with existing code.
>
> WARNING: __packed is preferred over __attribute__((packed))
> #141: FILE: fs/cifs/cifspdu.h:705:
> +           } __attribute__((packed)) challenge;
>
> WARNING: __packed is preferred over __attribute__((packed))
> #142: FILE: fs/cifs/cifspdu.h:706:
> +       } __attribute__((packed));
>
> total: 0 errors, 2 warnings, 99 lines checked
>
> Tested on cifs-2.6 for-linus (c481e9feee78c6ce1ba0a1c8c892049f6514f6cf) by mounting
> to iOS 10.8 and Win 8.0 Pro.
>
> rtg
>
>  fs/cifs/cifsencrypt.c |   40 ++++++++++++++++++++++++----------------
>  fs/cifs/cifspdu.h     |    8 +++++++-
>  2 files changed, 31 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index fc6f4f3..4934347 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -548,7 +548,13 @@ static int
>  CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>  {
>         int rc;
> -       unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
> +       struct ntlmv2_resp *ntlmv2 = (struct ntlmv2_resp *)
> +           (ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> +       unsigned int hash_len;
> +
> +       /* The MD5 hash starts at challenge_key.key */
> +       hash_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE +
> +               offsetof(struct ntlmv2_resp, challenge.key[0]));
>
>         if (!ses->server->secmech.sdeschmacmd5) {
>                 cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
> @@ -556,7 +562,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>         }
>
>         rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
> -                               ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
> +                                ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
>                          __func__);
> @@ -570,20 +576,21 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>         }
>
>         if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
> -               memcpy(ses->auth_key.response + offset,
> -                       ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
> +               memcpy(ntlmv2->challenge.key,
> +                      ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
>         else
> -               memcpy(ses->auth_key.response + offset,
> -                       ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
> +               memcpy(ntlmv2->challenge.key,
> +                      ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
>         rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
> -               ses->auth_key.response + offset, ses->auth_key.len - offset);
> +                                ntlmv2->challenge.key, hash_len);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
>                 return rc;
>         }
>
> +       /* Note that the MD5 digest over writes anon.challenge_key.key */
>         rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
> -               ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> +                               ntlmv2->ntlmv2_hash);
>         if (rc)
>                 cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
>
> @@ -627,7 +634,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>         int rc;
>         int baselen;
>         unsigned int tilen;
> -       struct ntlmv2_resp *buf;
> +       struct ntlmv2_resp *ntlmv2;
>         char ntlmv2_hash[16];
>         unsigned char *tiblob = NULL; /* target info blob */
>
> @@ -660,13 +667,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>         }
>         ses->auth_key.len += baselen;
>
> -       buf = (struct ntlmv2_resp *)
> +       ntlmv2 = (struct ntlmv2_resp *)
>                         (ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> -       buf->blob_signature = cpu_to_le32(0x00000101);
> -       buf->reserved = 0;
> -       buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
> -       get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
> -       buf->reserved2 = 0;
> +       ntlmv2->blob_signature = cpu_to_le32(0x00000101);
> +       ntlmv2->reserved = 0;
> +       /* Must be within 5 minutes of the server */
> +       ntlmv2->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
> +       get_random_bytes(&ntlmv2->client_chal, sizeof(ntlmv2->client_chal));
> +       ntlmv2->reserved2 = 0;
>
>         memcpy(ses->auth_key.response + baselen, tiblob, tilen);
>
> @@ -706,7 +714,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>         }
>
>         rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
> -               ses->auth_key.response + CIFS_SESS_KEY_SIZE,
> +               ntlmv2->ntlmv2_hash,
>                 CIFS_HMAC_MD5_HASH_SIZE);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 9e5ee34..33df36e 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -697,7 +697,13 @@ struct ntlmssp2_name {
>  } __attribute__((packed));
>
>  struct ntlmv2_resp {
> -       char ntlmv2_hash[CIFS_ENCPWD_SIZE];
> +       union {
> +           char ntlmv2_hash[CIFS_ENCPWD_SIZE];
> +           struct {
> +               __u8 reserved[8];
> +               __u8 key[CIFS_SERVER_CHALLENGE_SIZE];
> +           } __attribute__((packed)) challenge;
> +       } __attribute__((packed));
>         __le32 blob_signature;
>         __u32  reserved;
>         __le64  time;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
