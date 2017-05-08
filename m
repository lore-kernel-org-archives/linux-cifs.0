From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: Re: [RFC 08/10] cifs: move to generic async completion
Date: Mon, 8 May 2017 13:56:03 -0700
Message-ID: <CAKywueTvdNwnzwmMj+0qigZ24EZeksO0--t5mqwXN4r5a4C70g@mail.gmail.com>
References: <1494075602-5061-1-git-send-email-gilad@benyossef.com> <1494075602-5061-9-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keyrings@vger.kernel.org, linux-
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1494075602-5061-9-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2017-05-06 5:59 GMT-07:00 Gilad Ben-Yossef <gilad@benyossef.com>:
> cifs starts an async. crypto op and waits for their completion.
> Move it over to generic code doing the same.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  fs/cifs/smb2ops.c | 30 ++++--------------------------
>  1 file changed, 4 insertions(+), 26 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 152e37f..cee7bb3 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1706,22 +1706,6 @@ init_sg(struct smb_rqst *rqst, u8 *sign)
>         return sg;
>  }
>
> -struct cifs_crypt_result {
> -       int err;
> -       struct completion completion;
> -};
> -
> -static void cifs_crypt_complete(struct crypto_async_request *req, int err)
> -{
> -       struct cifs_crypt_result *res = req->data;
> -
> -       if (err == -EINPROGRESS)
> -               return;
> -
> -       res->err = err;
> -       complete(&res->completion);
> -}
> -
>  static int
>  smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
>  {
> @@ -1762,12 +1746,10 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
>         struct aead_request *req;
>         char *iv;
>         unsigned int iv_len;
> -       struct cifs_crypt_result result = {0, };
> +       DECLARE_CRYPTO_WAIT(wait);
>         struct crypto_aead *tfm;
>         unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
>
> -       init_completion(&result.completion);
> -
>         rc = smb2_get_enc_key(server, tr_hdr->SessionId, enc, key);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
> @@ -1825,14 +1807,10 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
>         aead_request_set_ad(req, assoc_data_len);
>
>         aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -                                 cifs_crypt_complete, &result);
> +                                 crypto_req_done, &wait);
>
> -       rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
> -
> -       if (rc == -EINPROGRESS || rc == -EBUSY) {
> -               wait_for_completion(&result.completion);
> -               rc = result.err;
> -       }
> +       rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
> +                               : crypto_aead_decrypt(req), &wait);
>
>         if (!rc && enc)
>                 memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

Best regards,
Pavel Shilovsky
