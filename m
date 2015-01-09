From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH RESEND] cifs: use memzero_explicit to clear stack buffer
Date: Fri, 9 Jan 2015 12:53:26 -0600
Message-ID: <CAH2r5mvyaZY6MpKCjPbhpV1q-QC_EB8p6i94OqAAUaG7gs5PKA@mail.gmail.com>
References: <1420394744-20268-1-git-send-email-me@mortis.eu> <1420580220-6276-1-git-send-email-me@mortis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>, "moderated list:COMMON INTERNET F..." <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
To: Giel van Schijndel <me@mortis.eu>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1420580220-6276-1-git-send-email-me@mortis.eu>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Looks fine to me - will merge into cifs-2.6.git

On Tue, Jan 6, 2015 at 3:37 PM, Giel van Schijndel <me@mortis.eu> wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear stack allocated buffers. memset(0) may be optimized away.
>
> This particular buffer is highly likely to contain sensitive data which
> we shouldn't leak (it's named 'passwd' after all).
>
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> Reported-at: http://www.viva64.com/en/b/0299/
> Reported-by: Andrey Karpov
> Reported-by: Svyatoslav Razmyslov
> ---
>  fs/cifs/smbencrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 6c15663..a4232ec 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -221,7 +221,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
>         }
>
>         rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__le16));
> -       memset(wpwd, 0, 129 * sizeof(__le16));
> +       memzero_explicit(wpwd, sizeof(wpwd));
>
>         return rc;
>  }
> --
> 2.1.4
>



-- 
Thanks,

Steve
