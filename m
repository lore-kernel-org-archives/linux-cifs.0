From: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cifs.upcall: allow cifs.upcall to grab
 $KRB5CCNAME from initiating process
Date: Tue, 14 Feb 2017 17:33:07 -0500
Message-ID: <1487111587.31734.48.camel@redhat.com>
References: <20170214182325.25067-1-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214182325.25067-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2017-02-14 at 13:23 -0500, Jeff Layton wrote:
> Small respin of the patches that I posted a few days ago. The main
> difference is the reordering of the series to make it do the group
> and grouplist manipulation first, and then the patch that makes
> it grab the KRB5CCNAME from the initiating process.
> 
> I think the code is sound, my main question is whether we really
> need the command-line switch for this. Should this just be the
> default mode of operation?
> 
> Jeff Layton (2):
>   cifs.upcall: switch group IDs when handling an upcall
>   cifs.upcall: allow scraping of KRB5CCNAME out of initiating task's
>     /proc/<pid>/environ file
> 
>  cifs.upcall.8.in |  10 +++
>  cifs.upcall.c    | 185
> +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 189 insertions(+), 6 deletions(-)

I think I'd make it the default, but maybe leave a way to disable env
scraping with a reverse flag.

Simo.
