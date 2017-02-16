From: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cifs-utils PATCH v3 0/4] cifs.upcall: allow cifs.upcall to
 scrape cache location initiating task's environment
Date: Thu, 16 Feb 2017 08:59:00 -0500
Message-ID: <1487253540.6697.3.camel@redhat.com>
References: <20170215161522.17063-1-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215161522.17063-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2017-02-15 at 11:15 -0500, Jeff Layton wrote:
> Apologies for v3 series, I had some extra patches in there. This is
> the one that should have been sent. Relabeled as v4 for clarity.
> 
> Third respin of this series. Reordered for better safety for bisecting.
> The environment scraping is now on by default, but can be disabled with
> "-E" in environments where it's not needed.
> 
> Also, I've added a patch to make cifs.upcall drop capabilities before
> doing most of its work. This may help reduce the attack surface of the
> program.
> 
> Jeff Layton (4):
>   cifs.upcall: convert two flags from int to bool
>   cifs.upcall: switch group IDs when handling an upcall
>   cifs.upcall: drop capabilities early in program
>   cifs.upcall: allow scraping of KRB5CCNAME out of initiating task's
>     /proc/<pid>/environ file
> 
>  Makefile.am      |   2 +-
>  cifs.upcall.8.in |   9 ++
>  cifs.upcall.c    | 255 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 256 insertions(+), 10 deletions(-)
> 

You can add a reviewed-by with my name.

Simo.

-- 
Simo Sorce * Red Hat, Inc * New York
