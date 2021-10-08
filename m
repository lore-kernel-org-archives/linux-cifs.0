Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9ABC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 01:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 550346121F
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 01:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhJHBvN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 21:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhJHBvN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Oct 2021 21:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BB96121F
        for <linux-cifs@vger.kernel.org>; Fri,  8 Oct 2021 01:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633657757;
        bh=Aipd13PFJqjDtH/CyCZl2s6REUvS4n1mM7m25j8BHoc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=It42gke6t/Ov0dh6uBGbuAAlDcPZ0yaH8mt6foYjd0XWDAvzbpjQzpFqJBsb3ziQg
         S9Xbge63kqn+qlKf8SVyl7JfKn7f+dCnkxZFS/ovfenbNKMSFSa9j6zwO7Gg8Z8+46
         n3lO5ff+kHAz+0QUSifVHmvOGa/hk6Z/TWJxSbQzgwLoc6uTlBJsGQ2A3Mn9HYP9F0
         eyQYiwxfCVUbzeif7DEDC9J1FhSFiczpoANX6iuAVWg0aEOALOgRUuhlAb+IEtoNW8
         TMc/1CqlLzi3a0ZVISqSWhI0nSRZ+hV7usTMm69H3woe4zdGimNHoiVVsFbBAGMuI/
         IorWY1rKs3tQw==
Received: by mail-oi1-f173.google.com with SMTP id y207so8534833oia.11
        for <linux-cifs@vger.kernel.org>; Thu, 07 Oct 2021 18:49:17 -0700 (PDT)
X-Gm-Message-State: AOAM531O8qBt3ecG2T9cc/SfzkHG4UFcDqgZGTMhlVmsYwYoBshfzNOj
        83vs0aP+xJ2+ewgIOy+TuzRxBC5LQ+KrS5Ps9AE=
X-Google-Smtp-Source: ABdhPJyHrSfiSIYVqxq5d12pY16yrxHVWqGb4MrwJGPaMLTRXt0enU6nRd+ZiuzS7tjT+wuZDDiBVEjAp9m/12II4PA=
X-Received: by 2002:a05:6808:64f:: with SMTP id z15mr13783249oih.65.1633657757035;
 Thu, 07 Oct 2021 18:49:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 7 Oct 2021 18:49:16 -0700 (PDT)
In-Reply-To: <20211006161442.4724-1-ematsumiya@suse.de>
References: <20211006161442.4724-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 8 Oct 2021 10:49:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-NF1VuCoRX54bd7SEBoY0uO+sOf0-mmye_YpP7xyjF0A@mail.gmail.com>
Message-ID: <CAKYAXd-NF1VuCoRX54bd7SEBoY0uO+sOf0-mmye_YpP7xyjF0A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: update README
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,
2021-10-07 1:14 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Prettify README with markdown and fix some typos/commands.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  README    | 98 -------------------------------------------------------
>  README.md | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+), 98 deletions(-)
>  delete mode 100644 README
>  create mode 100644 README.md
>
> diff --git a/README b/README
> deleted file mode 100644
> index 3dce3bb41c6e..000000000000
> --- a/README
> +++ /dev/null
> @@ -1,98 +0,0 @@
> -________________________
> -BUILDING KSMBD TOOLS
> -________________________
> -
> -Install preprequisite packages:
> -	For Ubuntu:
> -	sudo apt-get install autoconf libtool pkg-config libnl-3-dev \
> -	libnl-genl-3-dev libglib2.0-dev
> -
> -	For Fedora, RHEL:
> -	sudo yum install autoconf automake libtool glib2-devel libnl3-devel
> -
> -	For CentOS:
> -	sudo yum install glib2-devel libnl3-devel
> -
> -Build steps:
> -        - cd into the ksmbd-tools directory
> -        - ./autogen.sh
> -        - ./configure
> -        - make
> -        - make install
> -
> -_____________________
> -USING KSMBD TOOLS
> -_____________________
> -
> -Setup steps:
> -	- install smbd kernel driver
> -		modprobe ksmbd
> -	- create user/password for SMB share
> -		mkdir /etc/ksmbd/
> -		ksmbd.adduser -a <Enter USERNAME for SMB share access>
> -		Enter password for SMB share access
> -	- create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
> -		Refer smb.conf.example
> -	- start smbd user space daemon
> -		ksmbd.mountd
> -	- access share from Windows or Linux using CIFS
> -
> -_____________________
> -RESTART KSMBD
> -_____________________
> -
> -steps:
> -	- kill user and kernel space daemon
> -		sudo ksmbd.control -s
> -	- restart user space daemon
> -		ksmbd.mountd
> -
> -_____________________
> -Shutdown KSMBD
> -_____________________
> -
> -steps:
> -	- kill user and kernel space daemon
> -		sudo ksmbd.control -s
> -	- unload ksmbd module
> -		rmmod ksmbd
> -
> -
> -_____________________
> -Enable debug prints
> -_____________________
> -
> -steps:
> -	- Enable all component prints
> -		sudo ksmbd.control -d "all"
> -	- Enable one of components(smb, auth, vfs, oplock, ipc, conn, rdma)
> -		sudo ksmbd.control -d "smb"
> -	- Disable prints:
> -		If you try the selected component once more, It is disabled without
> brackets.
> -
> -
> ---------------------
> -ADMIN TOOLS
> ---------------------
> -
> -- ksmbd.adduser
> -	Adds, updates or removes (-a/-u/-d) a user from ksmbd pwd file.
> -
> -- ksmbd.addshare
> -	Adds, updates or removes (-a/-u/-d) a net share from smb.conf file.
> -
> -Usage example:
> -
> -Creating a new share:
> -
> -ksmbd.addshare -a files -o "\
> -		     path=/home/users/files \
> -		     comment=exported files \
> -		     writeable=yes \
> -		     read only = no \
> -		     "
> -
> -Note that share options (-o) must always be enquoted ("...").
> -
> -ksmbd.addshare tool does not modify [global] smb.conf section; only net
> -share configs are supported at the moment.
> diff --git a/README.md b/README.md
> new file mode 100644
> index 000000000000..b6e4915dc6ff
> --- /dev/null
> +++ b/README.md
> @@ -0,0 +1,86 @@
> +# ksmbd-tools
> +
> +### Building
> +
> +##### Install prerequisite packages:
> +
> +- For Ubuntu:
> +  - `sudo apt-get install autoconf libtool pkg-config libnl-3-dev
> libnl-genl-3-dev libglib2.0-dev`
> +
> +- For Fedora, RHEL:
> +  - `sudo yum install autoconf automake libtool glib2-devel libnl3-devel`
> +
> +- For CentOS:
> +  - `sudo yum install glib2-devel libnl3-devel`
> +
> +- For openSUSE:
> +  - `sudo zypper install glib2-devel libnl3-devel`
> +
> +##### Building:
> +
> +- clone this repository
> +- `cd ksmbd-tools`
> +- `./autogen.sh`
> +- `./configure`
> +- `make`
> +- `make install`
> +
> +
> +### Usage
> +
> +All administration tasks must be done as root.
> +
> +##### Setup:
> +
> +- Install ksmbd kernel driver
> +	- `modprobe ksmbd`
> +- Create user/password for SMB share
> +	- `mkdir /etc/ksmbd`
> +	- `ksmbd.adduser -a <username>`
> +	- Enter password for SMB share access
> +- Create `/etc/ksmbd/smb.conf` file
> +	- Refer `smb.conf.example`
> +- Add share to `smb.conf`
> +	- This can be done manually or with `ksmbd.addshare`, e.g.:
> +	- `ksmbd.addshare -a myshare -o "guest ok = yes, writable = yes, path =
> /mnt/data"`
> +
> +	- Note: share options (-o) must always be enclosed with double quotes
> ("...").
> +- Start ksmbd user space daemon
> +	- `ksmbd.mountd`
> +- Access share from Windows or Linux using CIFS
> +
> +
> +##### Stopping and restarting the daemon:
> +
> +- Kill user and kernel space daemon
> +  - `ksmbd.control -s`
> +- To restart user space daemon
> +  - `ksmbd.mountd`
> +- To shut it down
> +  - `rmmod ksmbd`
It is unclear to me. ksmbd.mountd is still alive.
If session is still opening, We need to call "ksmbd.control -s" first
to kill server(both ksmbd.mountd and ksmbd kernel thread).

> +
> +
> +### Debugging
> +
> +- Enable all component prints
> +  - `ksmbd.control -d "all"`
> +- Enable a single component (see below)
> +  - `ksmbd.control -d "smb"`
> +- Run the command with the same component name again to disable it
> +		
ERROR: trailing whitespace
#263: FILE: README.md:70:
+^I^I$

Thanks!
> +Currently available debug components:
> +smb, auth, vfs, oplock, ipc, conn, rdma
> +
> +
> +### More...
> +
> +- ksmbd.adduser
> +  - Adds (-a), updates (-u), or deletes (-d) a user from user database.
> +  - Default database file is `/etc/ksmbd/users.db`
> +
> +- ksmbd.addshare
> +  - Adds (-a), updates (-u), or deletes (-d) a net share from config file.
> +  - Default config file is `/etc/ksmbd/smb.conf`
> +
> +`ksmbd.addshare` does not modify `[global]` section in config file; only
> net
> +share configs are supported at the moment.
> --
> 2.33.0
>
>
