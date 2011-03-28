From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH 2/2] Consolidate and extract similar DFS referral
	expansion code in cifs_mount
Date: Mon, 28 Mar 2011 10:38:03 +0200
Message-ID: <20110328083803.GA12639@cobija.connexer.com>
References: <c28ea395ebc40d7f886a4f0cccc0cf50c66946fa.1301063020.git.sean.finney@sonyericsson.com> <de9908cf62bd6be5640f7cd0dcaf13aad12c3c53.1301063020.git.sean.finney@sonyericsson.com> <20110325165110.00690165@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110325165110.00690165-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

On Fri, Mar 25, 2011 at 04:51:10PM -0400, Jeff Layton wrote:
> Not that I'm trying to give you more work to do, but I think it would
> have meant less code churn to break the existing code out into a
> separate function first, and then add the new call site to this
> function second. It certainly would make this easier to review...

I thought about that afterwards, actually, but (a) Since I'm not familiar with
the codebase I had to attack the problem from the other direction (I
wasn't sure what to split out without having the duplicate code to look
over) and (b) I was on the bus by the time I thought about that, meaning
it would have to wait until today :)

If it's a big problem let me know and I'll re-re-factor.

> > +	/* For DFS paths, skip the first '\' of the UNC */
> > +	ref_path = (check_prefix)?(full_path + 1):(volume_info->UNC + 1);
> > +
> 
> No need for extra parenthesis here. You should run this through
> scripts/checkpatch.pl and fix the style warnings.

Will do.

> > -			if (mount_data != mount_data_global)
> > -				kfree(mount_data);
> > -
> > -			mount_data = cifs_compose_mount_options(
> > -					cifs_sb->mountdata, full_path + 1,
> > -					referrals, &fake_devname);
> > -
> > -			free_dfs_info_array(referrals, num_referrals);
> > -			kfree(fake_devname);
> > -			kfree(full_path);
> >  
> > -			if (IS_ERR(mount_data)) {
> > -				rc = PTR_ERR(mount_data);
> > -				mount_data = NULL;
> > -				goto mount_fail_check;
> > -			}
> > +		if (mount_data != mount_data_global)
> > +			kfree(mount_data);
> >  
> 
> Problem: suppose mount_data != mount_data_global. You kfree it here but
> the pointer is still the same. Now you call expand_dfs_referral and
> let's suppose that get_dfs_path returns an error. We eventually find
> our way to the bottom of the function and free the pointer again.
> 
> This is not your fault of course, but rather due to the fact that this
> mount_data/mount_data_global thing is completely fubar. Since you're in
> here anyway, care to see about cleaning that up? It seems like there
> has to be a less error prone way to handle that stuff.

Yeah I'll take a look.  I'll poke you on IRC if I have any questions.


	sean
