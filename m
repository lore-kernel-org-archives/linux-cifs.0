From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
Date: Thu, 1 Dec 2011 16:32:38 -0600
Message-ID: <CAH2r5mvwAzgqCggwRQuhSbCBM2NGeao_hqPFjNyW5yqr_48zSA@mail.gmail.com>
References: <4ED56C12.1040708@gmail.com>
	<4ED5C047.6040500@linux.vnet.ibm.com>
	<20111130062502.68d9db59@tlielax.poochiereds.net>
	<4ED6AF7B.9090101@gmail.com>
	<20111201063315.5aa68bd4@tlielax.poochiereds.net>
	<4ED7B55F.5010703@linux.vnet.ibm.com>
	<4ED7B9A0.7060900@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Linux PM mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Belisko Marek <marek.belisko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED7B9A0.7060900-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have we eliminated build errors or module load errors (maybe touch the
version number in cifsfs.h so we can doublecheck in
/proc/fs/cifs/DebugData that they are in fact running the patched
module?)

On Thu, Dec 1, 2011 at 11:30 AM, Srivatsa S. Bhat
<srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> On 12/01/2011 10:41 PM, Srivatsa S. Bhat wrote:
>
>> On 12/01/2011 05:03 PM, Jeff Layton wrote:
>>
>>> On Wed, 30 Nov 2011 17:34:35 -0500
>>> Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>>> Jeff Layton wrote:
>>>>> On Wed, 30 Nov 2011 11:03:59 +0530
>>>>> "Srivatsa S. Bhat"<srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> =A0wrote:
>>>>>
>>>>>> Adding linux-pm, Jeff Layton and others to CC.
>>>>>>
>>>>>> Regards,
>>>>>> Srivatsa S. Bhat
>>>>>>
>>>>>> On 11/30/2011 05:04 AM, Woody Suwalski wrote:
>>>>>>
>>>>>>> With CIFS mount present, suspend2ram seems to be failing on 3.2=
=2E0-rc3.
>>>>>>> It may be similar to recent NFS suspend issues?
>>>>>>>
>>>>>>> I have done couple of suspends, then did mount.cifs (at 555 sec=
onds),
>>>>>>> and then tried suspend again. =A0The problem is easy to duplica=
te.
>>>>>>>
>>>>>>> The hardware is a netbook Asus EeePC.
>>>>>>> I guess will find out if:
>>>>>>> - cifs for real 3.2 fixes the problem
>>>>>>> - NFS fix for -rc4 work for CIFS as well...
>>>>>>>
>>>>>>> Thanks, Woody
>>>>>>>
>>>>>>>
>>>>>>> [ =A0153.974532] uhci_hcd 0000:00:1d.1: PCI INT B disabled
>>>>>>> [ =A0153.974578] uhci_hcd 0000:00:1d.0: PCI INT A disabled
>>>>>>> [ =A0153.975774] i915 0000:00:02.0: PCI INT A disabled
>>>>>>> [ =A0153.977210] ACPI handle has no context!
>>>>>>> [ =A0153.977302] atl2 0000:03:00.0: PCI INT A disabled
>>>>>>> [ =A0153.977316] ACPI handle has no context!
>>>>>>> [ =A0154.277181] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
>>>>>>> [ =A0154.288119] PM: suspend of devices complete after 414.210 =
msecs
>>>>>>> [ =A0154.299212] ehci_hcd 0000:00:1d.7: PME# enabled
>>>>>>> [ =A0154.299257] ehci_hcd 0000:00:1d.7: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0154.310114] uhci_hcd 0000:00:1d.3: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0154.310178] uhci_hcd 0000:00:1d.2: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0154.310235] uhci_hcd 0000:00:1d.1: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0154.310293] uhci_hcd 0000:00:1d.0: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0154.310418] PM: late suspend of devices complete after 22.=
283 msecs
>>>>>>> [ =A0154.310451] ACPI: Preparing to enter system sleep state S3
>>>>>>> [ =A0154.311671] PM: Saving platform NVS memory
>>>>>>> [ =A0154.312968] Disabling non-boot CPUs ...
>>>>>>> [ =A0154.312968] ACPI: Low-level resume complete
>>>>>>> [ =A0154.312968] PM: Restoring platform NVS memory
>>>>>>> [ =A0154.312968] Force enabled HPET at resume
>>>>>>> [ =A0154.313366] ACPI: Waking up from system sleep state S3
>>>>>>> [ =A0154.341485] snd_hda_intel 0000:00:1b.0: restoring config s=
pace at
>>>>>>> offset 0x1 (was 0x100006, writing 0x100002)
>>>>>>> [ =A0154.341550] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x9 (was 0x1fff1, writing 0x10511041)
>>>>>>> [ =A0154.341566] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x8 (was 0xfff0, writing 0x10301020)
>>>>>>> [ =A0154.341580] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x7 (was 0xf0, writing 0x3030)
>>>>>>> [ =A0154.341603] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x1 (was 0x100104, writing 0x100507)
>>>>>>> [ =A0154.341689] pcieport 0000:00:1c.1: restoring config space =
at offset
>>>>>>> 0x9 (was 0x1fff1, writing 0x10111001)
>>>>>>> [ =A0154.341705] pcieport 0000:00:1c.1: restoring config space =
at offset
>>>>>>> 0x7 (was 0xf0, writing 0x2020)
>>>>>>> [ =A0154.341728] pcieport 0000:00:1c.1: restoring config space =
at offset
>>>>>>> 0x1 (was 0x100106, writing 0x100507)
>>>>>>> [ =A0154.341812] pcieport 0000:00:1c.2: restoring config space =
at offset
>>>>>>> 0x7 (was 0xf0, writing 0x1010)
>>>>>>> [ =A0154.341834] pcieport 0000:00:1c.2: restoring config space =
at offset
>>>>>>> 0x1 (was 0x100106, writing 0x100507)
>>>>>>> [ =A0154.341920] uhci_hcd 0000:00:1d.0: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0154.341958] uhci_hcd 0000:00:1d.0: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0154.342004] uhci_hcd 0000:00:1d.1: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0154.342086] uhci_hcd 0000:00:1d.1: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0154.342137] uhci_hcd 0000:00:1d.2: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0154.342166] uhci_hcd 0000:00:1d.2: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0154.342211] uhci_hcd 0000:00:1d.3: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0154.342239] uhci_hcd 0000:00:1d.3: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0154.342296] ehci_hcd 0000:00:1d.7: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2900006, writing 0x2900002)
>>>>>>> [ =A0154.342335] ehci_hcd 0000:00:1d.7: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0154.342349] ehci_hcd 0000:00:1d.7: PME# disabled
>>>>>>> [ =A0154.342374] pci 0000:00:1e.0: restoring config space at of=
fset 0xf
>>>>>>> (was 0x60000, writing 0x600ff)
>>>>>>> [ =A0154.342606] atl2 0000:03:00.0: restoring config space at o=
ffset 0x1
>>>>>>> (was 0x100006, writing 0x100406)
>>>>>>> [ =A0154.343209] PM: early resume of devices complete after 1.9=
41 msecs
>>>>>>> [ =A0154.343454] i915 0000:00:02.0: PCI INT A -> =A0GSI 16 (lev=
el, low) ->
>>>>>>> IRQ 16
>>>>>>> [ =A0154.343470] i915 0000:00:02.0: setting latency timer to 64
>>>>>>> [ =A0154.347098] snd_hda_intel 0000:00:1b.0: PCI INT A -> =A0GS=
I 16 (level,
>>>>>>> low) -> =A0IRQ 16
>>>>>>> [ =A0154.347117] snd_hda_intel 0000:00:1b.0: setting latency ti=
mer to 64
>>>>>>> [ =A0154.347218] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI=
-X
>>>>>>> [ =A0154.347424] uhci_hcd 0000:00:1d.0: PCI INT A -> =A0GSI 23 =
(level, low)
>>>>>>> -> =A0IRQ 23
>>>>>>> [ =A0154.347442] uhci_hcd 0000:00:1d.0: setting latency timer t=
o 64
>>>>>>> [ =A0154.347479] usb usb2: root hub lost power or was reset
>>>>>>> [ =A0154.347543] uhci_hcd 0000:00:1d.1: PCI INT B -> =A0GSI 19 =
(level, low)
>>>>>>> -> =A0IRQ 19
>>>>>>> [ =A0154.347559] uhci_hcd 0000:00:1d.1: setting latency timer t=
o 64
>>>>>>> [ =A0154.347593] usb usb3: root hub lost power or was reset
>>>>>>> [ =A0154.347653] uhci_hcd 0000:00:1d.2: PCI INT C -> =A0GSI 18 =
(level, low)
>>>>>>> -> =A0IRQ 18
>>>>>>> [ =A0154.347670] uhci_hcd 0000:00:1d.2: setting latency timer t=
o 64
>>>>>>> [ =A0154.347702] usb usb4: root hub lost power or was reset
>>>>>>> [ =A0154.347760] uhci_hcd 0000:00:1d.3: PCI INT D -> =A0GSI 16 =
(level, low)
>>>>>>> -> =A0IRQ 16
>>>>>>> [ =A0154.347776] uhci_hcd 0000:00:1d.3: setting latency timer t=
o 64
>>>>>>> [ =A0154.347808] usb usb5: root hub lost power or was reset
>>>>>>> [ =A0154.347867] ehci_hcd 0000:00:1d.7: PCI INT A -> =A0GSI 23 =
(level, low)
>>>>>>> -> =A0IRQ 23
>>>>>>> [ =A0154.347884] ehci_hcd 0000:00:1d.7: setting latency timer t=
o 64
>>>>>>> [ =A0154.347988] pci 0000:00:1e.0: setting latency timer to 64
>>>>>>> [ =A0154.348125] ata_piix 0000:00:1f.2: PCI INT B -> =A0GSI 19 =
(level, low)
>>>>>>> -> =A0IRQ 19
>>>>>>> [ =A0154.348140] ata_piix 0000:00:1f.2: setting latency timer t=
o 64
>>>>>>> [ =A0154.354172] atl2 0000:03:00.0: PCI INT A -> =A0GSI 17 (lev=
el, low) ->
>>>>>>> IRQ 17
>>>>>>> [ =A0154.354192] atl2 0000:03:00.0: setting latency timer to 64
>>>>>>> [ =A0154.354309] atl2 0000:03:00.0: irq 44 for MSI/MSI-X
>>>>>>> [ =A0154.354722] sd 1:0:0:0: [sda] Starting disk
>>>>>>> [ =A0154.525453] ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (SET FE=
ATURES)
>>>>>>> filtered out
>>>>>>> [ =A0154.525470] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FE=
ATURES)
>>>>>>> filtered out
>>>>>>> [ =A0154.531325] ata2.00: configured for UDMA/66
>>>>>>> [ =A0154.591089] usb 1-5: reset high-speed USB device number 2 =
using ehci_hcd
>>>>>>> [ =A0154.805066] PM: resume of devices complete after 461.739 m=
secs
>>>>>>> [ =A0154.805801] Restarting tasks ... done.
>>>>>>> [ =A0154.832376] video LNXVIDEO:00: Restoring backlight state
>>>>>>> [ =A0155.964388] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex=
>
>>>>>>> [ =A0265.377852] PM: Syncing filesystems ... done.
>>>>>>> [ =A0265.427397] Freezing user space processes ... (elapsed 0.0=
1 seconds)
>>>>>>> done.
>>>>>>> [ =A0265.438118] Freezing remaining freezable tasks ... (elapse=
d 0.01
>>>>>>> seconds) done.
>>>>>>> [ =A0265.449211] Suspending console(s) (use no_console_suspend =
to debug)
>>>>>>> [ =A0265.451744] sd 1:0:0:0: [sda] Stopping disk
>>>>>>> [ =A0265.555169] ata_piix 0000:00:1f.2: PCI INT B disabled
>>>>>>> [ =A0265.555281] ehci_hcd 0000:00:1d.7: PCI INT A disabled
>>>>>>> [ =A0265.555336] uhci_hcd 0000:00:1d.3: PCI INT D disabled
>>>>>>> [ =A0265.555384] uhci_hcd 0000:00:1d.2: PCI INT C disabled
>>>>>>> [ =A0265.555432] uhci_hcd 0000:00:1d.1: PCI INT B disabled
>>>>>>> [ =A0265.555479] uhci_hcd 0000:00:1d.0: PCI INT A disabled
>>>>>>> [ =A0265.555639] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
>>>>>>> [ =A0265.556302] i915 0000:00:02.0: PCI INT A disabled
>>>>>>> [ =A0265.558207] ACPI handle has no context!
>>>>>>> [ =A0265.558302] atl2 0000:03:00.0: PCI INT A disabled
>>>>>>> [ =A0265.558316] ACPI handle has no context!
>>>>>>> [ =A0265.569117] PM: suspend of devices complete after 119.214 =
msecs
>>>>>>> [ =A0265.580216] ehci_hcd 0000:00:1d.7: PME# enabled
>>>>>>> [ =A0265.580261] ehci_hcd 0000:00:1d.7: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0265.591121] uhci_hcd 0000:00:1d.3: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0265.591186] uhci_hcd 0000:00:1d.2: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0265.591244] uhci_hcd 0000:00:1d.1: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0265.591302] uhci_hcd 0000:00:1d.0: wake-up capability enab=
led by ACPI
>>>>>>> [ =A0265.591581] PM: late suspend of devices complete after 22.=
446 msecs
>>>>>>> [ =A0265.591615] ACPI: Preparing to enter system sleep state S3
>>>>>>> [ =A0265.592832] PM: Saving platform NVS memory
>>>>>>> [ =A0265.594133] Disabling non-boot CPUs ...
>>>>>>> [ =A0265.594133] ACPI: Low-level resume complete
>>>>>>> [ =A0265.594133] PM: Restoring platform NVS memory
>>>>>>> [ =A0265.594133] Force enabled HPET at resume
>>>>>>> [ =A0265.594133] ACPI: Waking up from system sleep state S3
>>>>>>> [ =A0265.621463] snd_hda_intel 0000:00:1b.0: restoring config s=
pace at
>>>>>>> offset 0x1 (was 0x100006, writing 0x100002)
>>>>>>> [ =A0265.621528] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x9 (was 0x1fff1, writing 0x10511041)
>>>>>>> [ =A0265.621544] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x8 (was 0xfff0, writing 0x10301020)
>>>>>>> [ =A0265.621559] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x7 (was 0xf0, writing 0x3030)
>>>>>>> [ =A0265.621582] pcieport 0000:00:1c.0: restoring config space =
at offset
>>>>>>> 0x1 (was 0x100104, writing 0x100507)
>>>>>>> [ =A0265.621667] pcieport 0000:00:1c.1: restoring config space =
at offset
>>>>>>> 0x9 (was 0x1fff1, writing 0x10111001)
>>>>>>> [ =A0265.621684] pcieport 0000:00:1c.1: restoring config space =
at offset
>>>>>>> 0x7 (was 0xf0, writing 0x2020)
>>>>>>> [ =A0265.621706] pcieport 0000:00:1c.1: restoring config space =
at offset
>>>>>>> 0x1 (was 0x100106, writing 0x100507)
>>>>>>> [ =A0265.621791] pcieport 0000:00:1c.2: restoring config space =
at offset
>>>>>>> 0x7 (was 0xf0, writing 0x1010)
>>>>>>> [ =A0265.621813] pcieport 0000:00:1c.2: restoring config space =
at offset
>>>>>>> 0x1 (was 0x100106, writing 0x100507)
>>>>>>> [ =A0265.621899] uhci_hcd 0000:00:1d.0: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0265.621938] uhci_hcd 0000:00:1d.0: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0265.621983] uhci_hcd 0000:00:1d.1: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0265.622057] uhci_hcd 0000:00:1d.1: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0265.622111] uhci_hcd 0000:00:1d.2: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0265.622139] uhci_hcd 0000:00:1d.2: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0265.622183] uhci_hcd 0000:00:1d.3: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2800005, writing 0x2800001)
>>>>>>> [ =A0265.622210] uhci_hcd 0000:00:1d.3: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0265.622267] ehci_hcd 0000:00:1d.7: restoring config space =
at offset
>>>>>>> 0x1 (was 0x2900006, writing 0x2900002)
>>>>>>> [ =A0265.622305] ehci_hcd 0000:00:1d.7: wake-up capability disa=
bled by ACPI
>>>>>>> [ =A0265.622320] ehci_hcd 0000:00:1d.7: PME# disabled
>>>>>>> [ =A0265.622344] pci 0000:00:1e.0: restoring config space at of=
fset 0xf
>>>>>>> (was 0x60000, writing 0x600ff)
>>>>>>> [ =A0265.622575] atl2 0000:03:00.0: restoring config space at o=
ffset 0x1
>>>>>>> (was 0x100006, writing 0x100406)
>>>>>>> [ =A0265.623172] PM: early resume of devices complete after 1.9=
25 msecs
>>>>>>> [ =A0265.623416] i915 0000:00:02.0: PCI INT A -> =A0GSI 16 (lev=
el, low) ->
>>>>>>> IRQ 16
>>>>>>> [ =A0265.623432] i915 0000:00:02.0: setting latency timer to 64
>>>>>>> [ =A0265.627096] snd_hda_intel 0000:00:1b.0: PCI INT A -> =A0GS=
I 16 (level,
>>>>>>> low) -> =A0IRQ 16
>>>>>>> [ =A0265.627115] snd_hda_intel 0000:00:1b.0: setting latency ti=
mer to 64
>>>>>>> [ =A0265.627215] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI=
-X
>>>>>>> [ =A0265.627429] uhci_hcd 0000:00:1d.0: PCI INT A -> =A0GSI 23 =
(level, low)
>>>>>>> -> =A0IRQ 23
>>>>>>> [ =A0265.627448] uhci_hcd 0000:00:1d.0: setting latency timer t=
o 64
>>>>>>> [ =A0265.627485] usb usb2: root hub lost power or was reset
>>>>>>> [ =A0265.627548] uhci_hcd 0000:00:1d.1: PCI INT B -> =A0GSI 19 =
(level, low)
>>>>>>> -> =A0IRQ 19
>>>>>>> [ =A0265.627564] uhci_hcd 0000:00:1d.1: setting latency timer t=
o 64
>>>>>>> [ =A0265.627597] usb usb3: root hub lost power or was reset
>>>>>>> [ =A0265.627659] uhci_hcd 0000:00:1d.2: PCI INT C -> =A0GSI 18 =
(level, low)
>>>>>>> -> =A0IRQ 18
>>>>>>> [ =A0265.627675] uhci_hcd 0000:00:1d.2: setting latency timer t=
o 64
>>>>>>> [ =A0265.627707] usb usb4: root hub lost power or was reset
>>>>>>> [ =A0265.627766] uhci_hcd 0000:00:1d.3: PCI INT D -> =A0GSI 16 =
(level, low)
>>>>>>> -> =A0IRQ 16
>>>>>>> [ =A0265.627781] uhci_hcd 0000:00:1d.3: setting latency timer t=
o 64
>>>>>>> [ =A0265.627814] usb usb5: root hub lost power or was reset
>>>>>>> [ =A0265.627873] ehci_hcd 0000:00:1d.7: PCI INT A -> =A0GSI 23 =
(level, low)
>>>>>>> -> =A0IRQ 23
>>>>>>> [ =A0265.627889] ehci_hcd 0000:00:1d.7: setting latency timer t=
o 64
>>>>>>> [ =A0265.627993] pci 0000:00:1e.0: setting latency timer to 64
>>>>>>> [ =A0265.628130] ata_piix 0000:00:1f.2: PCI INT B -> =A0GSI 19 =
(level, low)
>>>>>>> -> =A0IRQ 19
>>>>>>> [ =A0265.628145] ata_piix 0000:00:1f.2: setting latency timer t=
o 64
>>>>>>> [ =A0265.634153] atl2 0000:03:00.0: PCI INT A -> =A0GSI 17 (lev=
el, low) ->
>>>>>>> IRQ 17
>>>>>>> [ =A0265.634173] atl2 0000:03:00.0: setting latency timer to 64
>>>>>>> [ =A0265.634290] atl2 0000:03:00.0: irq 44 for MSI/MSI-X
>>>>>>> [ =A0265.634712] sd 1:0:0:0: [sda] Starting disk
>>>>>>> [ =A0265.796709] ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (SET FE=
ATURES)
>>>>>>> filtered out
>>>>>>> [ =A0265.796726] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FE=
ATURES)
>>>>>>> filtered out
>>>>>>> [ =A0265.803326] ata2.00: configured for UDMA/66
>>>>>>> [ =A0265.880091] usb 1-5: reset high-speed USB device number 2 =
using ehci_hcd
>>>>>>> [ =A0266.091960] PM: resume of devices complete after 468.673 m=
secs
>>>>>>> [ =A0266.092731] Restarting tasks ... done.
>>>>>>> [ =A0266.112098] video LNXVIDEO:00: Restoring backlight state
>>>>>>> [ =A0267.219459] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex=
>
>>>>>>> [ =A0554.912659] FS-Cache: Loaded
>>>>>>> [ =A0554.950749] FS-Cache: Netfs 'cifs' registered for caching
>>>>>>> [ =A0555.047550] CIFS VFS: default security mechanism requested=
=2E =A0The
>>>>>>> default security mechanism will be upgraded from ntlm to ntlmv2=
 in
>>>>>>> kernel release 3.2
>>>>>>> [ 2094.090461] PM: Syncing filesystems ... done.
>>>>>>> [ 2094.155385] Freezing user space processes ... (elapsed 0.01 =
seconds)
>>>>>>> done.
>>>>>>> [ 2094.166113] Freezing remaining freezable tasks ...
>>>>>>> [ 2114.175108] Freezing of tasks failed after 20.00 seconds (1 =
tasks
>>>>>>> refusing to freeze, wq_busy=3D0):
>>>>>>> [ 2114.175586] cifsd =A0 =A0 =A0 =A0 =A0 S ccb50b40 =A0 =A0 0 =A0=
2219 =A0 =A0 =A02 0x00800000
>>>>>>> [ 2114.175611] =A0cc6cc000 00000046 00000000 ccb50b40 cc776b40 =
cc41d000
>>>>>>> cc776780 cc61d960
>>>>>>> [ 2114.175635] =A0cc4d81c0 c178ec40 c178ec40 ccb50980 00000000 =
ccb50980
>>>>>>> c1031e88 00000001
>>>>>>> [ 2114.175660] =A0c1031f9f c10230f5 c1559ee1 c17a7140 c1031e88 =
00000001
>>>>>>> c1031f9f c10230f5
>>>>>>> [ 2114.175684] Call Trace:
>>>>>>> [ 2114.175710] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.175723] =A0[<c1031f9f>] ? add_preempt_count+0x5f/0xa0
>>>>>>> [ 2114.175747] =A0[<c10230f5>] ? default_spin_lock_flags+0x5/0x=
10
>>>>>>> [ 2114.175770] =A0[<c1559ee1>] ? _raw_spin_lock_irqsave+0x31/0x=
50
>>>>>>> [ 2114.175782] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.175794] =A0[<c1031f9f>] ? add_preempt_count+0x5f/0xa0
>>>>>>> [ 2114.175807] =A0[<c10230f5>] ? default_spin_lock_flags+0x5/0x=
10
>>>>>>> [ 2114.175820] =A0[<c1559ee1>] ? _raw_spin_lock_irqsave+0x31/0x=
50
>>>>>>> [ 2114.175832] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.175846] =A0[<c15588c1>] ? schedule_timeout+0x111/0x1d0
>>>>>>> [ 2114.175860] =A0[<c1512500>] ? tcp_rcv_established+0x170/0x76=
0
>>>>>>> [ 2114.175878] =A0[<c1041fa0>] ? usleep_range+0x40/0x40
>>>>>>> [ 2114.175897] =A0[<c14cb6e7>] ? sk_wait_data+0xa7/0xb0
>>>>>>> [ 2114.175920] =A0[<c104ffc0>] ? abort_exclusive_wait+0x90/0x90
>>>>>>> [ 2114.175943] =A0[<c1509948>] ? tcp_recvmsg+0x588/0xb80
>>>>>>> [ 2114.175956] =A0[<c1001c0a>] ? __switch_to+0xea/0x1d0
>>>>>>> [ 2114.175976] =A0[<c1008e97>] ? native_sched_clock+0x27/0x90
>>>>>>> [ 2114.175993] =A0[<c152685f>] ? inet_recvmsg+0x6f/0xb0
>>>>>>> [ 2114.176063] =A0[<c14c7f70>] ? sock_recvmsg+0xe0/0x120
>>>>>>> [ 2114.176086] =A0[<c1242df8>] ? timerqueue_add+0x58/0xb0
>>>>>>> [ 2114.176098] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.176112] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.176123] =A0[<c1031f07>] ? sub_preempt_count+0x67/0xa0
>>>>>>> [ 2114.176145] =A0[<c1559d1b>] ? _raw_spin_unlock_irqrestore+0x=
1b/0x40
>>>>>>> [ 2114.176165] =A0[<c1053a43>] ? hrtimer_try_to_cancel+0x43/0xa=
0
>>>>>>> [ 2114.176178] =A0[<c1053ab1>] ? hrtimer_cancel+0x11/0x20
>>>>>>> [ 2114.176191] =A0[<c155934c>] ? schedule_hrtimeout_range_clock=
+0xcc/0x170
>>>>>>> [ 2114.176206] =A0[<c10536c0>] ? update_rmtp+0x80/0x80
>>>>>>> [ 2114.176219] =A0[<c14c7fe7>] ? kernel_recvmsg+0x37/0x50
>>>>>>> [ 2114.176268] =A0[<d0611228>] ? cifs_readv_from_socket+0x148/0=
x2b0 [cifs]
>>>>>>> [ 2114.176283] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.176309] =A0[<d06113ac>] ? cifs_read_from_socket+0x1c/0x2=
0 [cifs]
>>>>>>> [ 2114.176333] =A0[<d0611522>] ? cifs_demultiplex_thread+0x112/=
0xc20 [cifs]
>>>>>>> [ 2114.176348] =A0[<c1031e88>] ? get_parent_ip+0x8/0x20
>>>>>>> [ 2114.176370] =A0[<d0611410>] ? dequeue_mid+0x60/0x60 [cifs]
>>>>>>> [ 2114.176391] =A0[<c104f9c9>] ? kthread+0x69/0x70
>>>>>>> [ 2114.176406] =A0[<c104f960>] ? kthread_worker_fn+0x150/0x150
>>>>>>> [ 2114.176420] =A0[<c155af76>] ? kernel_thread_helper+0x6/0xd
>>>>>>> [ 2114.176466]
>>>>>>> [ 2114.176473] Restarting tasks ... done.
>>>>>>> [ 2114.201577] video LNXVIDEO:00: Restoring backlight state
>>>>>>> [ 2114.210975] lxpanel[1452]: segfault at 0 ip b6ead703 sp bfea=
8924
>>>>>>> error 4 in libc-2.13.so[b6e39000+13e000]
>>>>>>> --
>>>>> Thanks for reporting this. Does the following patch fix it?
>>>>>
>>>>> -----------------------[snip]------------------------
>>>>>
>>>>> cifs: attempt to freeze while looping on a receive attempt
>>>>>
>>>>> In the recent overhaul of the demultiplex thread receive path, we
>>>>> neglected to ensure that we attempt to freeze on each pass throug=
h the
>>>>> loop.
>>>>>
>>>>> Reported-by: Woody Suwalski<terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> Signed-off-by: Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>> ---
>>>>> =A0 fs/cifs/connect.c | =A0 =A02 ++
>>>>> =A0 1 files changed, 2 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>>>> index bf82f88..d166e3a 100644
>>>>> --- a/fs/cifs/connect.c
>>>>> +++ b/fs/cifs/connect.c
>>>>> @@ -441,6 +441,8 @@ cifs_readv_from_socket(struct TCP_Server_Info=
 *server, struct kvec *iov_orig,
>>>>> =A0 =A0smb_msg.msg_controllen =3D 0;
>>>>>
>>>>> =A0 =A0for (total_read =3D 0; to_read; total_read +=3D length, to=
_read -=3D length) {
>>>>> + =A0 =A0 =A0 =A0 =A0try_to_freeze();
>>>>> +
>>>>> =A0 =A0 =A0 =A0 =A0 =A0if (server_unresponsive(server)) {
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0total_read =3D -EAGAIN;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>>>> Jeff, I have tested on a similar EeePC box - the same cifsd crash.
>>>> The patch did not help...
>>>>
>>>> Woody
>>>>
>>>
>>> Well, that is odd then...
>>>
>>> First, we should clarify here: This is not a crash. The above stack
>>> trace is just telling us that the freezer wasn't able to freeze the
>>> cifs kthread that handles the receive codepath. It's possible that =
the
>>> userspace code wasn't able to deal with that and you had to reboot =
your
>>> machine after this, but that's really a separate problem if so.
>>>
>>> cifsd does blocking receives. When it creates a socket, it does thi=
s:
>>>
>>> =A0 =A0 =A0 =A0 socket->sk->sk_rcvtimeo =3D 7 * HZ;
>>>
>>> ...so the maximum amount of time that this code ought to sit in
>>> kernel_recvmsg is ~7s. If kernel_recvmsg returns certain error code=
s
>>> (like -EAGAIN), it'll sleep for another second or two before going
>>> around the loop again. So the max time that a loop iteration takes
>>> should always be less than ~10s.
>>>
>>> With the above patch, cifsd will try_to_freeze() on each pass throu=
gh
>>> the loop. If that didn't fix the problem, and you got the same stac=
k
>>> trace, then that suggests that the time being spent in kernel_recvm=
sg
>>> is more than 20s. Perhaps this is due to some lower-level networkin=
g
>>> problem?
>>>
>>
>>
>> Hey, looking at the error logs again, I see that cifsd is in "S" sta=
te,
>> meaning it is sleeping in TASK_INTERRUPTIBLE state. And, in fs/cifs/=
connect.c,
>> in cifs_demultiplex_thread() function, I see set_freezable(), which =
is
>> more than enough to allow the freezer to freeze this kernel thread i=
f it
>> is sleeping interruptibly.
>> In other words, we should not be getting freezing failures here at a=
ll!
>>
>> Not sure what could be going wrong here...
>>
>
>
> Sorry, interruptible sleep + set_freezable() only ensures that the fr=
eezer
> can wake the kernel thread from sleep. Calling try_to_freeze() after =
waking
> up is still the kernel thread's job, and without doing that soon enou=
gh the
> kernel thread won't get frozen and freezing failures will occur.
>
> So Jeff's patch should have solved the issue IMO, but ...
>
> Thanks,
> Srivatsa S. Bhat
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
