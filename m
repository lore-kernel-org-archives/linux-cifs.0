From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cifs: check kzalloc return
Date: Wed, 19 Dec 2018 02:57:04 -0800
Message-ID: <6ef8274c8fc7adb7903cf3874fbab1098881ed4c.camel@perches.com>
References: <1545150439-26055-1-git-send-email-hofrat@osadl.org>
         <4db484684a6e9b096c7fdf57673fd208d1c4005a.camel@perches.com>
         <20181219072250.GA18501@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181219072250.GA18501@osadl.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 2018-12-19 at 08:22 +0100, Nicholas Mc Guire wrote:
> On Tue, Dec 18, 2018 at 09:33:58AM -0800, Joe Perches wrote:
> > On Tue, 2018-12-18 at 17:27 +0100, Nicholas Mc Guire wrote:
> > > kzalloc can return NULL so a check is needed. While there is a
> > > check for ret_buf there is no check for the allocation of
> > > ret_buf->crfid.fid - this check is thus added. Both call-sites
> > > of tconInfoAlloc() check for NULL return of tconInfoAlloc()
> > > so returning NULL on failure of kzalloc() here seems appropriate.
> > > As the kzalloc() is the only thing here that can fail it is
> > > moved to the beginning so as not to initialize other resources
> > > on failure of kzalloc.
> > > 
> > Perhaps use a more common style by returning early on the
> > first possible failure too so the block can be unindented.
[]
> > yup the restructured cleanup would be the better way to go
> 
> rather than making this two patches I guess it would be the
> best to just skip the intermediate kzalloc only cleanup -
> atleast I see little value in that intermediat step - so
> could you take care of the kzalloc() in your refactoring 
> please ?

I did that in the patch I proposed, which is trivial.
If you want to take it, please do.

If you want a sign-off:

Signed-off-by: Joe Perches <joe@perches.com>

> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
[]
> > @@ -111,21 +111,27 @@ struct cifs_tcon *
> >  tconInfoAlloc(void)
> >  {
> >  	struct cifs_tcon *ret_buf;
> > -	ret_buf = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
> > -	if (ret_buf) {
> > -		atomic_inc(&tconInfoAllocCount);
> > -		ret_buf->tidStatus = CifsNew;
> > -		++ret_buf->tc_count;
> > -		INIT_LIST_HEAD(&ret_buf->openFileList);
> > -		INIT_LIST_HEAD(&ret_buf->tcon_list);
> > -		spin_lock_init(&ret_buf->open_file_lock);
> > -		mutex_init(&ret_buf->crfid.fid_mutex);
> > -		ret_buf->crfid.fid = kzalloc(sizeof(struct cifs_fid),
> > -					     GFP_KERNEL);
> > -		spin_lock_init(&ret_buf->stat_lock);
> > -		atomic_set(&ret_buf->num_local_opens, 0);
> > -		atomic_set(&ret_buf->num_remote_opens, 0);
> > +
> > +	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
> > +	if (!ret_buf)
> > +		return NULL;
> > +	ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid), GFP_KERNEL);
> > +	if (!ret_buf->crfid.fid) {
> > +		kfree(ret_buf);
> > +		return NULL;
> >  	}
> > +
> > +	atomic_inc(&tconInfoAllocCount);
> > +	ret_buf->tidStatus = CifsNew;
> > +	++ret_buf->tc_count;
> > +	INIT_LIST_HEAD(&ret_buf->openFileList);
> > +	INIT_LIST_HEAD(&ret_buf->tcon_list);
> > +	spin_lock_init(&ret_buf->open_file_lock);
> > +	mutex_init(&ret_buf->crfid.fid_mutex);
> > +	spin_lock_init(&ret_buf->stat_lock);
> > +	atomic_set(&ret_buf->num_local_opens, 0);
> > +	atomic_set(&ret_buf->num_remote_opens, 0);
> > +
> >  	return ret_buf;
> >  }
> >  
