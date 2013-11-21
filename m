From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: posix remove acl support
Date: Wed, 20 Nov 2013 23:35:00 -0600
Message-ID: <CAH2r5mtppAjXFw_8fdTcDvepOPL55it9G7K8J6PtWVQsxzxcYw@mail.gmail.com>
References: <CAH2r5mvcidQk7C47ZSFLPZ0yaU2yzzAabWDK2f19VMxBi3NzTg@mail.gmail.com>
	<20131121051600.GA1007@jeremy-HP>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131121051600.GA1007@jeremy-HP>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 20, 2013 at 11:16 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, Nov 20, 2013 at 11:04:57PM -0600, Steve French wrote:
>> Jeremy,
>> As you noted we need to add support to cifs kernel client to remove POSIX ACLs.
>>
>> This patch is close (it seems to work, but wireshark did not like the
>> buffer lengths when I did a setfacl -k although setacl -b looked fine.
>>
>> It works basically by passing the minimum size in for the ACL (0
>> entries) - sending a zero in the number of ACEs removes the entry.
>>
>> Comments/feedback?
>
> Yep, sending a zero size for the number of ACE entries
> will delete the ACL on the Samba server side.
>
> I don't have the capability to test your patch right now
> though, but you should be able to test it against any
> modern Samba server installation.

Looks fine so far (with the exception of the on the wire formatting
problem in one case above - which samba seems ok with or wireshark has
a bug - need to check tomorrow)


-- 
Thanks,

Steve
