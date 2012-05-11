From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Fri, 11 May 2012 13:21:29 -0400
Message-ID: <20120511132129.3cd77403@corrin.poochiereds.net>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
	<20120506100129.0b2f626b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120506100129.0b2f626b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 6 May 2012 10:01:29 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:


> >  
> > +#ifdef CONFIG_CIFS_SMB2
> > +	if (volume_info->use_smb2)
> > +		tcp_ses->is_smb2 = true;
> > +#endif /* CONFIG_CIFS_SMB2 */
> > +
> 
> The above should instead set a pointer to a "struct
> protocol_operations" or something. That struct could have a version
> field within it and it would give you a mechanism to allow for
> protocol-version specific behavior without resorting to sprinkling
> "is_smb2" checks all over the code.
> 

Steve had some confusion about the above statement, so I've hacked out
a small patchset to demonstrate what I'm been talking about. It's in
the "smb2-ops" branch of my git tree if you'd like to take a look.

http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/smb2-ops

The basic idea is to declare a smb_version_operations struct for each
ver= option that we want to support, and then set a pointer to that in
the TCP_Server_Info. We'll then have fields in there that are smb
version specific. Some might be populated in every one (like the
version_string field). Others not, (like the send_cancel function). In
the cases where they're not, the caller will need to deal with it.

In any case, this allows us to add SMB2 support without sprinkling
"is_smb2" checks all over the place, and more importantly gets rid of
the #ifdefs inside most of the code too. Whereever you have a "is_smb2"
check wrapped inside an ifdef now, you'd add a new ops vector to this
struct and populate it accordingly.

Thoughts?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
