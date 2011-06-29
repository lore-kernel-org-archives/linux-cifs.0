From: Bill Good <bgood-mO0wGsvBftXk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Can't mount CIFS shares under kernel version 3.0-1-generic
Date: Wed, 29 Jun 2011 16:40:51 -0400
Message-ID: <4E0B8DD3.5050804@velocity.net>
References: <4E014592.3070209@velocity.net>	<4E04806B.90303@velocity.net> <BANLkTik+=XK4mC6cn8xCekLaCqHBc3JUxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik+=XK4mC6cn8xCekLaCqHBc3JUxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On 06/24/2011 08:57 AM, Pavel Shilovsky wrote:
> 2011/6/24 Bill Good<bgood-mO0wGsvBftXk1uMJSBkQmQ@public.gmane.org>:
>>
>> On 06/21/2011 09:29 PM, Bill Good wrote:
>>> I have been trying to get this working for a couple of days and according
>>> to the LinuxCIFS troubleshooting page this is where I should be asking my
>>> question. I am testing Ubuntu Oneiric (11.10) and have a new D-Link DNS-320
>>> ShareCenter that I am trying to get to mount on 3.0-1-generic. It is working
>>> fine on 2.6.39-02063901-generic so thinking there is something that changed
>>> when we moved to the 3.0 kernel. If I am in the wrong place please let me
>>> know I will find the correct place. I have included the info that was
>>> suggested from the above mentioned page.
>>>
>>> bill@billsim-1110-64:~$ uname -r
>>> 3.0-1-generic
>>> bill@billsim-1110-64:~$ mount.cifs -V
>>> mount.cifs version: 4.9
>>>
>>> When using the command
>>> sudo mount -t cifs -o guest //192.168.0.189/Volume_1/test/
>>> /media/bills-dns-game-1110-64test
>>> with Ubuntu 11.10 kernel 3.0-1-generic it fails to mount.
>>>
>>> If I use the same mount command with Ubuntu 11.10 kernel
>>> 2.6.39-02063901-generic
>>> It mounts correctly.
>>>
>>> D-Link DNS-320 ShareCenter NAS
>>>
>>> Thanks Bill
>> I have found my problem with not be able to mount under kernel 3.0. I was
>> using the guest option and that is what seems to not be working in 3.0 but
>> did work in 2.6.39. When I use this command with kernels 3.0-0, 3.0-1 and
>> 3.0-rc4 it works correctly. Not sure where the issue is but as a side result
>> if you try with the guest option my system would not shutdown or reboot and
>> had to use Alt+Sys reisub to get it to shut down. I hope I have been of some
>> help in tracking my issue to help in resolving it.
>>
>> sudo mount -t cifs -o credentials=/media/.creds
>> //192.168.0.189/Volume_1/test/ /media/bills-dns-game-1110-64test
>>
>> Thanks Bill
>>
> It looks like the same issue as we have in "[OOPS] 3.0-rc1 cifs"
> thread. It is going to be fixed in 3.0-rc5 with this commit:
> http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=commit;h=446b23a75804d7ffa4cca2d4d8f0afb822108c7e.
>
I have tested using Ubuntu 11.10 64bit 3.0-rc5 and it does appear to be 
fixed. Forgot to reply to all.

Thanks Bill
