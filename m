From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 10/15] fs: cifs: check kmalloc() result
Date: Mon, 19 Jul 2010 14:50:20 -0400
Message-ID: <20100719145020.205ece82@tlielax.poochiereds.net>
References: <1279296925-25147-1-git-send-email-segooon@gmail.com>
	<1279298130.26876.12.camel@shaggy-w500>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>, Joe Perches <joe@perches.com>,
	Tejun Heo <tj@kernel.org>, samba-technical@lists.samba.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1279298130.26876.12.camel@shaggy-w500>
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

On Fri, 16 Jul 2010 11:35:30 -0500
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Fri, 2010-07-16 at 20:15 +0400, Kulikov Vasiliy wrote:
> > If kmalloc() fails exit with -ENOMEM.
> 
> Looks good to me.  Add my ack if you want it.
> 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> 
> Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> > ---
> >  fs/cifs/readdir.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index daf1753..d5e591f 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -847,6 +847,11 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
> >  		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
> > 
> >  		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
> > +		if (tmp_buf == NULL) {
> > +			rc = -ENOMEM;
> > +			break;
> > +		}
> > +
> >  		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
> >  			if (current_entry == NULL) {
> >  				/* evaluate whether this case is an error */
> 

Looks good to me too.

Acked-by: Jeff Layton <jlayton@redhat.com>
