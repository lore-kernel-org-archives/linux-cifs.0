From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix MUST SecurityFlags filtering
Date: Mon, 26 Jan 2015 19:40:02 -0600
Message-ID: <CAH2r5msDma05E3gO73jdzubvt4NB5rwvG1WrA5Z48obgL6LNYw@mail.gmail.com>
References: <1421932594-5878-1-git-send-email-niklass@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>, Niklas Cassel <niklass@axis.com>
To: Niklas Cassel <niklas.cassel@axis.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1421932594-5878-1-git-send-email-niklass@axis.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git

On Thu, Jan 22, 2015 at 7:16 AM, Niklas Cassel <niklas.cassel@axis.com> wrote:
> If CONFIG_CIFS_WEAK_PW_HASH is not set, CIFSSEC_MUST_LANMAN
> and CIFSSEC_MUST_PLNTXT is defined as 0.
>
> When setting new SecurityFlags without any MUST flags,
> your flags would be overwritten with CIFSSEC_MUST_LANMAN (0).
>
> Signed-off-by: Niklas Cassel <niklass@axis.com>
> ---
>  fs/cifs/cifs_debug.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 9c56ef7..7febcf2 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -606,9 +606,11 @@ cifs_security_flags_handle_must_flags(unsigned int *flags)
>                 *flags = CIFSSEC_MUST_NTLMV2;
>         else if ((*flags & CIFSSEC_MUST_NTLM) == CIFSSEC_MUST_NTLM)
>                 *flags = CIFSSEC_MUST_NTLM;
> -       else if ((*flags & CIFSSEC_MUST_LANMAN) == CIFSSEC_MUST_LANMAN)
> +       else if (CIFSSEC_MUST_LANMAN &&
> +                (*flags & CIFSSEC_MUST_LANMAN) == CIFSSEC_MUST_LANMAN)
>                 *flags = CIFSSEC_MUST_LANMAN;
> -       else if ((*flags & CIFSSEC_MUST_PLNTXT) == CIFSSEC_MUST_PLNTXT)
> +       else if (CIFSSEC_MUST_PLNTXT &&
> +                (*flags & CIFSSEC_MUST_PLNTXT) == CIFSSEC_MUST_PLNTXT)
>                 *flags = CIFSSEC_MUST_PLNTXT;
>
>         *flags |= signflags;
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
