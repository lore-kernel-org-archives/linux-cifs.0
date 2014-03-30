From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS Mount Error -5
Date: Sun, 30 Mar 2014 17:07:18 -0500
Message-ID: <CAH2r5mv3CHmfTSWc5-KeSjuwDC73fFYj8RY3R=wLHP3a2_AcVw@mail.gmail.com>
References: <02a101cf4c5c$83e79c10$8bb6d430$@pcsourcenet.com>
 <CAH2r5mvjVmLbpAg5N8++c1gzWA4rSX=qgnXzR1KLi3TMgn87nw@mail.gmail.com> <02b201cf4c61$ed475f10$c7d61d30$@pcsourcenet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hamid Majidy <hamid-1WA2RWJAdEzQnzwC+xcbyw@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02b201cf4c61$ed475f10$c7d61d30$@pcsourcenet.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Next obvious thing to try - compare the verbose mount string between
the failing case (where you started with a tcp name for the server)
and the working case (where you used an ip address for the server) and
see if there is a difference.  2nd obvious thing to try - type "dmesg"
after the mount fails and see if it indicates which request failed
(negotiate, session setup or tree connect).  There could be subtle
issues related to authentication when the server name differs but it
is likely to be much simpler than that.    As a comparison point,
using a totally different implementation, you can try the same
experiment with smbclient (if that succeeds it might indicate that you
should change the default security "sec=" option that you try, perhaps
from to sec=ntlmssp).  If all else fails, we can look at a wireshark
trace or the server's log to see if it gives a clue as to why it is
rejecting the request.

The reason why it is so important to look at the log file (dmesg) on
the client (or on the server) is that the mount command restricts the
number of errors that cifs.ko can send back to a very small set.
Error EIO can be caused (obviously) by many server or even
authentication or network problems and is a catch all for many
different conditions.

On Sun, Mar 30, 2014 at 4:49 PM, Hamid Majidy <hamid-1WA2RWJAdEzQnzwC+xcbyw@public.gmane.org> wrote:
> Wow a response from Steve French himself! When I add -verbose, I get:
>
> [root@DataTest-DW ~]# mount.cifs //DataTarget.mydomain.com/case
> /win/nas02/Case --verbose -o
> username=Dataanalyticslinux-3Q2Tfjf0mexWk0Htik3J/w@public.gmane.org,password=*******
>
> mount.cifs kernel mount options:
> ip=172.18.0.40,unc=\\DataTarget-DW.mydomain.com\case,,ver=1,user=Dataanalyticslinux-3Q2Tfjf0mexWk0Htik3J/w@public.gmane.org,pass=********
>
> mount error(5): Input/output error
>
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> The -verbose switch does not seem to add much helpful detail.
>
>
>
> And, yes, mount.cifs is where you refer to:
>
> [root@DataTest-DW ~]# ls -l /sbin/mount.cifs
>
> -rwxr-xr-x. 1 root root 40544 Nov 22 05:56 /sbin/mount.cifs
>
>
>
> I thought this might be because of a missing PTR records in DNS, but it
> seems to be there:
>
> [root@DataTest-DW ~]# nslookup
>
>> set type=ptr
>
>> 172.18.0.40
>
> Server:         172.18.0.8
>
> Address:        172.18.0.8#53
>
>
>
> 136.0.18.172.in-addr.arpa       name = datatest-dw.mydomain.com.
>
> Any other ideas on why name fails but IP succeeds, given that name resolves
> to correct IP?
>
>
>
> Thanks,
>
> Hamid.
>
> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Sunday, March 30, 2014 2:25 PM
> To: Hamid Majidy
>
>
> Subject: Re: CIFS Mount Error -5
>
>
>
> IP name address resolution is done by /sbin/mount.cifs so ensure it is
> present.  If in doubt about what IP address was resolved mount verbosely
> (remember to specify -verbose before the list of mount options)
>
>
> On Mar 30, 2014 4:11 PM, "Hamid Majidy" <hamid-1WA2RWJAdEzQnzwC+xcbyw@public.gmane.org> wrote:
>>
>> Hello list. I am getting on my CentOS 5 & 6 servers' /var/log/messages
>> like:
>> Mar 24 20:54:47 server kernel:  CIFS VFS: cifs_mount failed w/return code
>> =
>> -5
>>
>> When I try to mount a Windows 2008 R2 share with:
>> mount.cifs //server_name/share /win/case -o
>> username='user_name',password='user_password'
>>
>> whereas when I do the exact same mount with IP it is successful.
>> mount.cifs //server_IP/share /win/case -o
>> username='user_name',password='user_password'
>>
>> I have checked DNS which does resolve the name correctly, added the entry
>> to
>> /etc/hosts (so resolver does not have to contact DNS), checked
>> /etc/resolv.conf, added 'strace' before command, added '-av' as argument
>> all
>> to no avail. I am just give on using the server name.
>>
>> This happening on CentOS 5.5, 5.6 & 6.5 with different versions of Samba
>> and
>> CIFS (on CentOS 6.5).
>>
>> Anyone have any ideas?
>>
>> Thanks,
>> Hamid.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
