From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 00/16] SMB 2.1/3 multicredit requests for reading/writing
Date: Mon, 28 Jul 2014 22:14:22 +0200
Message-ID: <53D6AF1E.4030804@samba.org>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

> The goal of this patchset is to add large MTU/multicredits support for reading and writing from the CIFS client to servers > that support SMB 2.1 and higher versions of the protocol.

Are looking at the returned capabilities from the server or just the
dialect?
The answer should really be the capability, it's wrong to rely on the
dialect...

metze
