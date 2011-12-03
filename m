From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs.upcall: revise scheme for picking a krb5 SPN
Date: Sat, 3 Dec 2011 05:54:12 -0500
Message-ID: <20111203055412.1b116df9@tlielax.poochiereds.net>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322052246-18707-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Nov 2011 07:44:02 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This patchset is a second attempt at overhauling the scheme to pick a
> SPN in cifs.upcall. The current code simply prefixes the "cifs/" to the
> hostname. If that fails, it prepends it with "host/" instead and tries
> again.
> 
> Over time, this scheme hasn't been ideal and we get occasional confused
> users on the mailing list who aren't sure why krb5 auth isn't working
> for them. This patchset attempts to revise that to make this easier. The
> changes are as follows:
> 
> - In discussion of the earlier patchset, Andrew pointed out that getting
>   a "host/" principal is probably wrong and we shouldn't do that. In AD,
>   "cifs/<host>" is generally an alias for "host/<host>" anyway. This
>   patchset eliminates that.
> 
> - since DNS is case-insensitive and most KDCs are case-sensitive, it's
>   probably advantageous to lowercase the hostname prior to constructing
>   the SPN.
> 
> - finally, in the event that the user provides an unqualified hostname,
>   we should try to guess the domain name if we fail to get a SPN
>   containing the unqualified name
> 
> This patchset does the above and seems to work correctly.
> 
> Suggestions and comments are welcome...
> 
> Thanks,
> 
> Jeff Layton (4):
>   cifs.upcall: move to an on-stack princ buffer
>   cifs.upcall: always lowercase the hostname
>   cifs.upcall: move to Andrew's suggested algorithm for picking a
>     principal
>   cifs.upcall: try and guess the domain name on unqualified names
> 
>  Makefile.am   |    2 +-
>  cifs.upcall.c |  110 ++++++++++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 87 insertions(+), 25 deletions(-)
> 

All 4 are merged...

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
