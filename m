From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DFS : Object is remote
Date: Thu, 13 Jun 2013 16:14:28 -0500
Message-ID: <CAH2r5msFcgP-eV3NEa0j7yxXOUWWcJSSh2OMnLno8QPO+43h4w@mail.gmail.com>
References: <A88483E8-9A66-47E6-ABF9-A1AA86B3F8D5@dashbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A88483E8-9A66-47E6-ABF9-A1AA86B3F8D5-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a tough issue - if you are doing an ls immediately followed by
a cd into the dfs link.   We plan to ask Microsoft next week if they
have any ideas how to detect the following sequence - ls of directory
which contains dfs link (client caches the dfs link for one second
thinking it is a directory), client cd into directory.   The problem
we have is that many variants of "ls" can potentially cause 1000s of
stat calls to be sent over the network for one ls (queyrpathinfo or
open/query/close) if we don't cache the output of readdir (SMB
FindFirst/FindNext), but if we do cache then we can mistake a
directory for a dfs link.  If that is the problem that you are running
into - the obvious solution is to turn off metadata attribute caching
(set actimeo=0 on mount).  Jeff suggested a patch which would prevent
us from caching information on directories which is returned from
FindFirst but that could cause a substantial degradation in
performance - and we have not researched the alternatives (higher
levels of FindFirst and QueryDir that may return hints we can use to
decide whether to cache such as different "LinkCount" or EA size or
some such).

On Thu, Jun 13, 2013 at 4:04 PM, Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org> wrote:
> Hello,
>
> I am in need to mount a DFS share on CentOS 6.4.  My kernel is 2.6.32-358.  I am having the trouble where if I mount a DFS root namespace, I cannot enter or ls the shared folders.  If I immediately try to ls the shared folder, I receive the error, "Object is remote".  If I first ls the root of the namespace and then subsequently ls the shared folder I get the error, "Invalid argument" or one time "Resource temporarily unavailable".
>
> I have searched the list archives and I see several mentions of this issue.  Is there a known workaround or a patch at this time?
>
> Thank you,
> Doug Clow
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
