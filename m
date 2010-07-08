From: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 8 Jul 2010 20:14:23 +0400
Message-ID: <469B064927F7461992FFB15852A3B90F@lan.jax.org.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,
After small research I was defined with a key format. It is a "user" key
type with the description in next format
ntlminit:host_ip_addr:username:domain for everyone host_ip_addr returned by
getaddrinfo() from host entered by the user. The domain field can be empty
and payload consists of plain password.

Now I am puting my keys directly in the session keyring. Whether it is
necessary to create separate keyring or it is possible to do without it?

Also I have thought over algorithm of addition of a key in session keyring.
If at least for one of the host's IP addresses there is a key with it in the
description (with the same username and domain name of course) new keys are
not will be added. Whether it is correct?

Regards,
Igor Druzhinin

----- Original Message ----- 
From: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sent: Tuesday, July 06, 2010 3:09 PM
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring


> On Tue, 6 Jul 2010 07:00:56 -0400
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> On Tue, 6 Jul 2010 14:04:44 +0400
>> "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > As I saw current kernel code had no method for checking from userspace
>> > is
>> > the entered credentials are wrong without mount. Is it's right?
>>
>> Correct. You really can't check without connecting to the server.
>
> We certainly could have this tool use libsmbclient to connect to the
> server and authenticate to test the creds. I wouldn't bother with that
> for the initial implementation though -- keep it simple. Still it's
> something to keep in mind while you're coding this up.
>
>>
>> > But if user want to update them there are should be a mechanism for
>> > clearing
>> > old or wrong creds. As my opinion it may be something like --clear
>> > option.
>>
>> Sounds good. You will want to be able to update or clear invalid creds.
>>
>> > Besides, is it right to store multiple identical creds in keyring or
>> > creds
>> > with the same user and domain_host name?
>>
>> Not sure that I see any point in multiple creds per user@host or
>> user@domain. Only one will ever be valid for each combination. Why
>> would you want multiple sets? How would you know which ones to use?
>>
>
>
> -- 
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> 
