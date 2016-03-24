From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: questions cifs.upcall.c
Date: Thu, 24 Mar 2016 11:24:27 -0400
Message-ID: <20160324112427.46b0ad33@synchrony.poochiereds.net>
References: <B6CF10CD-10A5-4A30-93D8-E89FE6ED0697@fhcrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B6CF10CD-10A5-4A30-93D8-E89FE6ED0697-q9hIisBwmLrYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 21 Mar 2016 17:37:35 +0000
"Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org> wrote:

> Jeff,
> 
> I am setting krb5.conf default_ccache_name = (shared mount point).  The MIT krb5 routines work fine with the shared drive, but cifs.upcall is not reading the /etc/krb5.conf file to find the new location.  Default search locations seem to be hard-coded into cifs.upcall.
> 
> I am using Ubuntu 14.04  cifs-utils 6.0.  I have also check Ubuntu 16.04 with cifs-util 6.5.
> 
> In 2009 you had a patch to read the krb5CCNAME environment variable, this patch has since been removed.  Setting the default path in krb5.conf seems to solve a lot of problems but cifs.upcall is not checking that location. Is there a reason why the krb5.conf is not checked?
> 
> WHY are we doing this?  We run a large linux cluster.  Users interact with a set of head nodes.  When users login to the headnotes their krb5 ticket is updated.  From head nodes users can run jobs on the Linux cluster.  The cluster nodes do not have updated tickets so users jobs fail.  So we would like to use a shared drive for the tickets so that all the cluster nodes have an updated ticket.
> 
> Thanks
> 
> John Dey
> Jidey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org
> John-pGYbrA4uTiZBDgjK7y7TUQ@public.gmane.org
> 
> 
> 

(cc'ing linux-cifs mailing list)

Hmm, it's been so long since I looked at that code, I've forgotten how
it works. Let's see...

        ccdir = resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, uid);              
        if (ccdir != NULL)                                                      
                find_krb5_cc(ccdir, uid, &best_cache, &best_time);              
        ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_cache,          
                              &best_time);                              


...and those CIFS_DEFAULT_* macros are:

#define CIFS_DEFAULT_KRB5_DIR           "/tmp"                                  
#define CIFS_DEFAULT_KRB5_USER_DIR      "/run/user/%U"

So yeah, it does seem to be hardcoded. Why was it written that way?
ISTR that older versions of krb5 libs made it hard to get to that
variable from the config file, but maybe I'm remembering wrong.

It probably wouldn't be too hard to fix, but you'd have to dig into the
krb5 library API. I doubt I'll have time to do that anytime soon. If
you or your OS vendor wants to propose some patches however, I'd be
happy to review (and eventually) merge them.

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
