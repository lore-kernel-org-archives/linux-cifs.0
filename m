From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Date: Sat, 2 Aug 2014 11:55:48 -0500
Message-ID: <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>

On Sat, Jul 26, 2014 at 5:28 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> If you are going to use memset before strncpy you must copy sizeof -1
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  fs/cifs/cifsencrypt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 4934347..dcca8b3 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>
>         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
>         if (password)
> -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
> +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
>
>         if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
>                 memcpy(lnm_session_key, password_with_pad,
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
