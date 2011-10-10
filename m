From: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Subject: Fwd: cifs ignores sysct setting
Date: Mon, 10 Oct 2011 15:48:55 +0200 (CEST)
Message-ID: <fd3c2938-7d3d-41ac-862a-026c5f0ccb1e@absint.swen.nu>
References: <099ae669-6de2-4566-926e-981066fed122@absint.swen.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <099ae669-6de2-4566-926e-981066fed122-VJN6hnAnNNsoZRmjwiK4Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



From: "Alexander Swen" <alex-UE4+9DRHXtc@public.gmane.org> 
To: "Suresh Jayaraman" <sjayaraman-IBi9RG/b67k@public.gmane.org> 
Sent: Monday, 10 October, 2011 3:44:47 PM 
Subject: Re: cifs ignores sysct setting 

Hi Suresh, thanks for your re, 

> It is not clear to me why do you want to unload and reload cifs 
> module 
> often? The general usage is load module during boot or on first use 
> and 
> the module lives on till the machine goes down. 

I don't (want to load cifs often ;-). but I don't want to exec a command to configure cifs once a server starts up). Now, I know I can automate such thing using rc.local etc... but I rather configure those things just as I would configure any other kernel module settings (preferably using modprobe.d/cifs.conf or something similar) 

> I'm not seeing an justification for making it an module parameter. 

I do: when I load for example a module like bonding I tell it how to behave in with settings which i put into a file called /etc/modprobe.d/aliases: 
alias bond0 bonding 
options bonding mode=1 miimon=100 


> Could you please explain more on how it will be useful? 

i would like to change the behaviour of cifs so that oplock is disabled when it loads. 

can you follow my way of thinking? 

thanks for your cooperation, 

Alex 
