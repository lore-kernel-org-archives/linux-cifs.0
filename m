From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH] accept all supported values for
 dir_mode
Date: Sun, 6 Jun 2010 07:33:03 -0400
Message-ID: <20100606073303.365579f5@tlielax.poochiereds.net>
References: <1275547159-30008-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-cifs-client@lists.samba.org
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Return-path: <linux-cifs-client-bounces@lists.samba.org>
In-Reply-To: <1275547159-30008-1-git-send-email-scott.lovenberg@gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/linux-cifs-client>
List-Post: <mailto:linux-cifs-client@lists.samba.org>
List-Help: <mailto:linux-cifs-client-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=subscribe>
Sender: linux-cifs-client-bounces@lists.samba.org
Errors-To: linux-cifs-client-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu,  3 Jun 2010 02:39:19 -0400
Scott Lovenberg <scott.lovenberg@gmail.com> wrote:

> The option parsing function now accepts all values for 'dir_mode' that are supported by the kernel side code.
> 
> Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>
> ---
>  mount.cifs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 65754c0..21ce532 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -812,7 +812,7 @@ static int parse_opt_token(const char *token)
>  		return OPT_FILE_MODE;
>  	if (strncmp(token, "dmask", 5) == 0)
>  		return OPT_DMASK;
> -	if (strncmp(token, "dir_mode", 8) == 0)
> +	if (strncmp(token, "dir_mode", 4) == 0 || strncmp(token, "dirm", 4) == 0)
				      ^^^^
Sigh. But I can confirm that this is similarly broken in the kernel
so we have little choice but to live with it here.

>  		return OPT_DIR_MODE;
>  	if (strncmp(token, "nosuid", 6) == 0)
>  		return OPT_NO_SUID;


Committed...
-- 
Jeff Layton <jlayton@samba.org>
