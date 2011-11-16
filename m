From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
 allocate memory
Date: Wed, 16 Nov 2011 09:28:14 +0530
Message-ID: <4EC334D6.9020208@suse.com>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com> <4EC269FC.1060104@suse.com> <004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org,
	'linux-cifs' <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/16/2011 12:57 AM, Justin Piszcz wrote:
> 
> 
> -----Original Message-----
> From: Suresh Jayaraman [mailto:sjayaraman-IBi9RG/b67k@public.gmane.org] 
> Sent: Tuesday, November 15, 2011 8:33 AM
> To: Justin Piszcz
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org; linux-cifs
> Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
> allocate memory
> 
> [Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
> 
> On 11/15/2011 12:34 AM, Justin Piszcz wrote:
>> Hi,
>>
>> CIFS "works" when I mount a Windows 7 host from my Linux host
> (3.1.1-x86_64)
>> but if I turn my machine off (Windows) and turn it back on, I get the
>> following error, is this normal? With NFS as a hardmount it just recovers,
>> with CIFS do I need to setup some sort of canary to unmount/remount?
>>
>>  $ ls /cifs_mnt
>> ls: cannot access /cifs_mnt: Cannot allocate memory
>>
> 
> This looks like a problem specific to Windows 7 or above. Quick tests on
> my test machines shows that cifs attempts to connect, times out,
> attempts to reconnect and gets -EHOSTUNREACH in case of both Windows
> Servers and Samba Servers. This is the expected behavior.
> 
> OTOH, this sounds like a problem related to an error due to the Windows
> server being unable to allocate from the system nonpaged pool (seen in
> the past). Do you see anything that is related to the error in Windows
> Event viewer?
> 
> Hi,
> 
> Yes, you are correct--
> 
> The server was unable to allocate from the system nonpaged pool because the
> server reached the configured limit for nonpaged pool allocations.
> 

Ah, ok. In case if you have not figured out how to overcome this
problem, take a look at


http://alan.lamielle.net/2009/09/03/windows-7-nonpaged-pool-srv-error-2017


- Suresh
