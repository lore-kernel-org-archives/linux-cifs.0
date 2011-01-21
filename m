From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: Replace cifs md5 hashing functions with kernel
 crypto APIs
Date: Fri, 21 Jan 2011 10:42:28 -0500
Message-ID: <20110121104228.60262dd2@tlielax.poochiereds.net>
References: <1295622245-10581-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org, metze@samba.org
To: shirishpargaonkar@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1295622245-10581-1-git-send-email-shirishpargaonkar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 21 Jan 2011 09:04:05 -0600
shirishpargaonkar@gmail.com wrote:

> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> 
> Replace remaining use of md5 hash functions local to cifs module
> with kernel crypto APIs.
> Remove header and source file containing those local functions.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> ---
>  fs/cifs/Makefile      |    2 +-
>  fs/cifs/cifsencrypt.c |    1 -
>  fs/cifs/link.c        |   59 +++++++--
>  fs/cifs/md5.c         |  366 -------------------------------------------------
>  fs/cifs/md5.h         |   38 -----
>  fs/cifs/smbencrypt.c  |    1 -
>  6 files changed, 51 insertions(+), 416 deletions(-)
>  delete mode 100644 fs/cifs/md5.c
>  delete mode 100644 fs/cifs/md5.h
> 

Very nice. The CIFS parts look good to me, and I'm always fond of
reducing the code we need to support as well as the cifs.ko footprint.
Assuming that mfsymlink support still works after this patch...

Reviewed-by: Jeff Layton <jlayton@redhat.com>
