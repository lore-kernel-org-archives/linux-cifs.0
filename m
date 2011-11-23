From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs.upcall: always lowercase the hostname
Date: Wed, 23 Nov 2011 14:05:36 +0100
Message-ID: <20111123130536.GA4143@cobija.connexer.com>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
 <1322052246-18707-3-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1322052246-18707-3-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 23, 2011 at 07:44:04AM -0500, Jeff Layton wrote:
> Most KDCs are case-sensitive (the notable exception being AD), but DNS
> is case-insensitive. To prevent admins from having to put in all
> possible case combinations of a principal, lowercase the hostname prior
> to trying to get a principal.

you'll have to excuse my ignorance if i'm missing something, but what
happens if the pricincpal *is* uppercase on the KDC?

	sean
