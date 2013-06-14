From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: DFS : Object is remote
Date: Thu, 13 Jun 2013 17:17:01 -0700
Message-ID: <86BFDC57-6087-4B75-81EA-18AE9360D456@dashbox.com>
References: <A88483E8-9A66-47E6-ABF9-A1AA86B3F8D5@dashbox.com> <CAH2r5msFcgP-eV3NEa0j7yxXOUWWcJSSh2OMnLno8QPO+43h4w@mail.gmail.com> <A90ADB0B-14D0-4F73-95E0-7A45130C031B@dashbox.com> <CAH2r5mu4BFpjp+RYGQQ+ogeQUK0ZZV7+jzZ7EW5OMVUNUYfqkw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu4BFpjp+RYGQQ+ogeQUK0ZZV7+jzZ7EW5OMVUNUYfqkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you so much.  I created a file dns_resolver.conf in /etc/request-key.d with the following content.
create  dns_resolver   * * /usr/sbin/cifs.upcall %k
After that I was able to enter the shared folders but I would get "Resource temporarily unavailable" for folders other than the first one I attempted.  After adding "actimeo=0" that problem was fixed as well.  

Regards,
Doug


On Jun 13, 2013, at 2:51 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Well  - that is good news.   Your problem is probably much easier ....
> 
> Have you ever been able to connect to a DFS referral - even with ip
> address (with hostname in dfs referral you have to have a dfs upcall
> helper to resolve hostnames instead of ip address).
> 
> On Thu, Jun 13, 2013 at 4:47 PM, Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org> wrote:
>> Hi Steve,
>> 
>> Thanks for the in depth response.  I tried your suggestion with setting actimeo=0, but didn't get any change on my end.  I may be experiencing a different issue as I've never been able to list the contents of or enter a shared folder from dfs using any order of commands.  I can mount the namespace and list the folders within, just not go inside the referrals.
>> 
>> Here's what I'm working with:  the system configuration is two Windows 2012 machines that host standalone DFS in a failover cluster.  The targets of the referrals are those same two servers, where each folder has both servers assigned as targets.  I have disabled SMB2/3 on both and set DFS to use DNS based referrals rather than Netbios in order to maximize Linux compatibility.  It didn't make a difference with default Netbios referrals or DNS based.
>> 
>> My mount command is:
>> 
>> mount.cifs //dfs.domain.com/namespace test -o sec=krb5,cruid=0,actimeo=0
>> 
>> I've also tried using standard ntlm authentication but it doesn't seem to make a difference.
>> 
>> Regards,
>> Doug
>> 
>> 
>> On Jun 13, 2013, at 2:14 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> 
>>> This is a tough issue - if you are doing an ls immediately followed by
>>> a cd into the dfs link.   We plan to ask Microsoft next week if they
>>> have any ideas how to detect the following sequence - ls of directory
>>> which contains dfs link (client caches the dfs link for one second
>>> thinking it is a directory), client cd into directory.   The problem
>>> we have is that many variants of "ls" can potentially cause 1000s of
>>> stat calls to be sent over the network for one ls (queyrpathinfo or
>>> open/query/close) if we don't cache the output of readdir (SMB
>>> FindFirst/FindNext), but if we do cache then we can mistake a
>>> directory for a dfs link.  If that is the problem that you are running
>>> into - the obvious solution is to turn off metadata attribute caching
>>> (set actimeo=0 on mount).  Jeff suggested a patch which would prevent
>>> us from caching information on directories which is returned from
>>> FindFirst but that could cause a substantial degradation in
>>> performance - and we have not researched the alternatives (higher
>>> levels of FindFirst and QueryDir that may return hints we can use to
>>> decide whether to cache such as different "LinkCount" or EA size or
>>> some such).
>>> 
>>> On Thu, Jun 13, 2013 at 4:04 PM, Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org> wrote:
>>>> Hello,
>>>> 
>>>> I am in need to mount a DFS share on CentOS 6.4.  My kernel is 2.6.32-358.  I am having the trouble where if I mount a DFS root namespace, I cannot enter or ls the shared folders.  If I immediately try to ls the shared folder, I receive the error, "Object is remote".  If I first ls the root of the namespace and then subsequently ls the shared folder I get the error, "Invalid argument" or one time "Resource temporarily unavailable".
>>>> 
>>>> I have searched the list archives and I see several mentions of this issue.  Is there a known workaround or a patch at this time?
>>>> 
>>>> Thank you,
>>>> Doug Clow
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>>> 
>>> 
>>> --
>>> Thanks,
>>> 
>>> Steve
>> 
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
