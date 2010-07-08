From: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 8 Jul 2010 21:28:34 +0400
Message-ID: <7E471FB7A6424D8595FEB4122BC8E0BA@lan.jax.org.ru>
References: <469B064927F7461992FFB15852A3B90F@lan.jax.org.ru> <20100708125915.5e4eb643@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As I have seen the domain name from domain= option parameter directly copied 
to SMB Session Setup packet in Primary Domain field that tells to server in 
what domain it is necessary to search for the information on an account. I 
think that short domain name that was entered in domain= field - for example 
LAN can be interpreted on one host as LAN.XXX.COM and LAN.YYY.COM on 
another.

----- Original Message ----- 
From: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sent: Thursday, July 08, 2010 8:59 PM
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring


> On Thu, 8 Jul 2010 20:14:23 +0400
> "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hello,
>> After small research I was defined with a key format. It is a "user" key
>> type with the description in next format
>> ntlminit:host_ip_addr:username:domain for everyone host_ip_addr returned 
>> by
>> getaddrinfo() from host entered by the user. The domain field can be 
>> empty
>> and payload consists of plain password.
>>
>
> Sounds reasonable. user keys are probably the best thing since they
> won't depend on having the cifs kmod loaded. The tricky part though is
> how to prevent password disclosure. We wouldn't want anyone to walk up
> to someone's machine after they've entered these creds and then be able
> to see what their passwords are.
>
>> Now I am puting my keys directly in the session keyring. Whether it is
>> necessary to create separate keyring or it is possible to do without it?
>>
>
> I don't think you need a separate keyring. The session keyring is
> probably fine, but maybe that would help the disclosure problem.
>
>> Also I have thought over algorithm of addition of a key in session 
>> keyring.
>> If at least for one of the host's IP addresses there is a key with it in 
>> the
>> description (with the same username and domain name of course) new keys 
>> are
>> not will be added. Whether it is correct?
>>
>
> Hmm, well...I was going on the assumption that a username will only
> have one password per host. There is a situation though where that
> wouldn't necessarily be the case -- if the server is running multiple
> SMB servers on different ports.
>
> Also, we probably need to consider the case of someone that has
> multiple mounts that use the same domain-level credentials, potentially
> to multiple servers. In that situation, you don't necessarily want to
> have to reenter the same creds for each IP address. It would be nice to
> be able to say "this username/password combo is for hosts in domain 
> EXAMPLE",
> and then tell the kernel at mount time "this host is in domain EXAMPLE" 
> and
> let the kernel use those credentials.
>
> The kernel already takes a domain= mount option, but it doesn't really
> do much now and could be used for this.
>
> For now, I'd probably recommend getting something working with just
> host-level credentials, and maybe add support for domain-level creds
> once you have that working.
>
> -- 
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> 
