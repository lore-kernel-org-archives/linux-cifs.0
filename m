From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 06/17] Add an AT_NO_AUTOMOUNT flag to suppress
 terminal automount
Date: Fri, 01 Oct 2010 16:55:47 +0800
Message-ID: <1285923347.3207.7.camel@localhost>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
	<20100930181526.30939.22704.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: autofs@linux.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ftp.linux.org.uk, linux-afs@lists.infradead.org,
        linux-fs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <autofs-bounces@linux.kernel.org>
In-Reply-To: <20100930181526.30939.22704.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/autofs>,
	<mailto:autofs-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/pipermail/autofs/>
List-Post: <mailto:autofs@linux.kernel.org>
List-Help: <mailto:autofs-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/autofs>,
	<mailto:autofs-request@linux.kernel.org?subject=subscribe>
Sender: autofs-bounces@linux.kernel.org
Errors-To: autofs-bounces@linux.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 2010-09-30 at 19:15 +0100, David Howells wrote:
> Add an AT_NO_AUTOMOUNT flag to suppress terminal automounting of directories
> with follow_link semantics.  This can be used by fstatat() users to permit the
> gathering of attributes on an automount point and also prevent
> mass-automounting of a directory of automount points by ls.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Ian Kent <raven@themaw.net>
> ---
> 
>  fs/namei.c            |    6 ++++++
>  fs/stat.c             |    4 +++-
>  include/linux/fcntl.h |    1 +
>  include/linux/namei.h |    2 ++
>  4 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 86421f9..74bce3a 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -625,6 +625,12 @@ static int follow_automount(struct path *path, unsigned flags,
>  	if (!path->dentry->d_op || !path->dentry->d_op->d_automount)
>  		return -EREMOTE;
>  
> +	/* We don't want to mount if someone supplied AT_NO_AUTOMOUNT
> +	 * and this is the terminal part of the path.
> +	 */
> +	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_CONTINUE))
> +		return -EXDEV; /* we actually want to stop here */

Oops, we missed this -EXDEV when we made the change to -EISDIR.

Ian
