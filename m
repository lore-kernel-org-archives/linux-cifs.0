From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] cifs.idmap: set timeout on keys and generic cleanups
Date: Mon, 29 Oct 2012 12:10:29 -0500
Message-ID: <CADT32e+XQETMgHUQ=3u7S26gOusF_V6QJHSY1tq31srBzyU=Zw@mail.gmail.com>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Oct 27, 2012 at 6:20 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> This patchset does a number of cleanups to the cifs.idmap request-key
> callout program. It also makes it so that it will set a timeout on the
> keys that it instantiates.
>
> Most of the fixes are to add extra bounds checking, fix unsigned vs.
> signed type confusion, and to avoid unnecessary memory allocations.
>
> Jeff Layton (7):
>   cifs.idmap: make sure cifsacl structs are packed
>   cifs.idmap: get rid of useless strcmp prior to idmapping
>   cifs.idmap: add an options struct to handle long options
>   cifs.idmap: clean up strget and avoid memory allocation
>   cifs.idmap: don't use atoi to convert unsigned int to number
>   cifs.idmap: set a timeout on keys that it instantiates
>   cifs.idmap: add a --help option for cifs.idmap
>
>  cifs.idmap.8.in |  12 +++++-
>  cifs.idmap.c    | 113 +++++++++++++++++++++++++++++++++++++++++---------------
>  cifsacl.h       |   8 ++--
>  3 files changed, 98 insertions(+), 35 deletions(-)
>
> --
> 1.7.11.7
>

Looks correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
