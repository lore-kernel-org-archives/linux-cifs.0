From: Steve French <smfrench@gmail.com>
Subject: Re: [patch] cifs: writing past the end of the array
Date: Sun, 6 Mar 2011 18:41:02 -0600
Message-ID: <AANLkTiksNTx5YCXfNWWfgY-6MAxE9sF2+HYpZ-hqLaZV@mail.gmail.com>
References: <20110306132621.GN3416@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	kernel-janitors@vger.kernel.org, samba-technical@lists.samba.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110306132621.GN3416@bicker>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

merged.  trivially correct.

On Sun, Mar 6, 2011 at 7:26 AM, Dan Carpenter <error27@gmail.com> wrote:

> This is a cut and paste error.  p16 only has 16 chars, not 21.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 3967635..1525d5e 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -353,7 +353,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
> unsigned char *p24)
>        int rc;
>        unsigned char p16[16], p21[21];
>
> -       memset(p16, '\0', 21);
> +       memset(p16, '\0', 16);
>        memset(p21, '\0', 21);
>
>        rc = E_md4hash(passwd, p16);
>



-- 
Thanks,

Steve
