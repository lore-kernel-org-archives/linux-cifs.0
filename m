From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 00/17] cifs-utils: userspace
 getcifsacl/setcifsacl/cifs.idmap
Date: Thu, 8 Nov 2012 06:58:35 -0500
Message-ID: <20121108065835.5e4feb72@tlielax.poochiereds.net>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat,  3 Nov 2012 08:50:17 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This patchset represents a number of fixes to the userspace getcifsacl,
> setcifsacl, and cifs.idmap tools. I *think* that with this set, the
> tools should now work properly on big-endian machines, but that still
> needs testing.
> 
> Jeff Layton (17):
>   setcifsacl: clean up sizing of cifs_sid
>   setcifsacl: fix overrun of subauths array when copying SIDs
>   setcifsacl: clean up get_numfaces
>   get/setcifsacl: set "prog" via basename(argv[0])
>   setcifsacl: declare an enum for the action values
>   setcifsacl: fix up getopt() usage
>   cifsacl: header file cleanup
>   setcifsacl: fix endianness on SIDs provided by winbind routines
>   cifs.idmap: fix endianness on SIDs before sending to kernel
>   setcifsacl: fix up endianness conversions
>   setcifsacl: clean up get_numcaces
>   setcifsacl: clean up parse_cmdline_aces
>   setcifsacl: fix verify_ace_sid
>   getcifsacl: clarify magic number if print_ace
>   getcifsacl: fix endianness before handing off SID to winbind
>   getcifsacl: don't use wbcDomainSid internally
>   getcifsacl: fix raw SID printing routine
> 
>  cifs.idmap.c |  23 +++++-
>  cifsacl.h    |  22 +++---
>  getcifsacl.c |  72 +++++++++++++------
>  setcifsacl.1 |   4 ++
>  setcifsacl.c | 230 ++++++++++++++++++++++++++++++-----------------------------
>  5 files changed, 204 insertions(+), 147 deletions(-)
> 

I've gone ahead and merged this set (along with the updated patches).
I'll plan to merge the remaining patches tomorrow unless there are
objections.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
