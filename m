From: Ted Miller <tmiller-fFyIe9EmHoY@public.gmane.org>
Subject: Re: Fwd: Re: xattr "trusted" namespace
Date: Tue, 11 Jun 2013 09:23:26 -0400
Message-ID: <51B724CE.5060706@hcjb.org>
References: <51B6584B.8010906@hcjb.org> <CAH2r5mswiwvRz1xT-PyhR+u65CKvdJtBBgB88oEncD5Bu-Bq_A@mail.gmail.com> <CAH2r5msjGgr9a4tLO5G_EwJedAr_ChJYo3Q5cQgYJBYPgdw32Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msjGgr9a4tLO5G_EwJedAr_ChJYo3Q5cQgYJBYPgdw32Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since I don't usually do things on the "bleeding edge" of the Linux kernel, 
could you give me a "ballpark" idea of when a 'stable' kernel version that 
includes this functionality might be out?
Ted Miller

On 6/10/2013 10:37 PM, Steve French wrote:
> I have patches for cifs kernel client for this.  Jeremy Allison was
> almost done server patches for samba for the other end.
>
> On Jun 10, 2013 6:06 PM, "Ted Miller" <tmiller-fFyIe9EmHoY@public.gmane.org> wrote:
>> (If this is the wrong place to ask this question, please feel free to point me in a different direction.)
>>
>> I am working on a system that needs to be able to write to the xattr namespace "trusted", as in trusted.xyz.  I only need this support from the Linux client, as the target file is being served by a Windows server.  I have tried this using Centos (same package versions as RHEL) 6.4, and the writes all fail with the default client.  I am hoping that this has been addressed in a newer version of the CIFS client.
>>
>> Is the "trusted" namespace accessible in the current Linux CIFS client?  If so, what version of which file(s) do I need to look for?
>>
>> Thank you,
>> Ted Miller
>> Elkhart, IN, USA
