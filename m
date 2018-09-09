From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs/cifs: require sha512
Date: Sun, 9 Sep 2018 00:05:20 -0500
Message-ID: <CAH2r5muE1e6L3hNQ4CWVjgO1RiaSEqTqO8LOf6R61jqKqT8YWw@mail.gmail.com>
References: <20180907162417.31977-1-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <stfrench@microsoft.com>,
        Stable <stable@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180907162417.31977-1-metze@samba.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6-git for-next
On Fri, Sep 7, 2018 at 11:25 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> This got lost in commit 0fdfef9aa7ee68ddd508aef7c98630cfc054f8d6,
> which removed CONFIG_CIFS_SMB311.
>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Fixes: 0fdfef9aa7ee68ddd ("smb3: simplify code by removing CONFIG_CIFS_SMB311")
> CC: Stable <stable@vger.kernel.org>
> CC: linux-cifs@vger.kernel.org
> ---
>  fs/cifs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 35c83fe7dba01..abcd78e332feb 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -6,6 +6,7 @@ config CIFS
>         select CRYPTO_MD4
>         select CRYPTO_MD5
>         select CRYPTO_SHA256
> +       select CRYPTO_SHA512
>         select CRYPTO_CMAC
>         select CRYPTO_HMAC
>         select CRYPTO_ARC4
> --
> 2.17.1
>


-- 
Thanks,

Steve
