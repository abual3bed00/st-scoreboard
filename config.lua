Config = Config or {}

Config.OpenKey = 'HOME'
Config.Toggle = true
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48)

-- الوظائف 
Config.TrackedJobs = {
    ['police'] = { label = 'Police', icon = 'fa-solid fa-handcuffs' },
    ['ambulance'] = { label = 'EMS', icon = 'fas fa-ambulance' },
    ['mechanic'] = { label = 'Mechanic', icon = 'fas fa-wrench' },
    ['realestate'] = { label = 'Real Estate', icon = 'fas fa-building' },
    ['taxi'] = { label = 'Taxi', icon = 'fas fa-taxi' },
}

-- إعدادات الخطف
Config.KidnapSettings = {
    civilian = {
        minimumPolice = 2,      -- يحتاج على الأقل شرطيان ليكون مسموحاً
        busy = false,
        label = 'Kidnap Civilian',
        icon = 'fa-user'
    },
    police = {
        minimumPolice = 4,       -- يحتاج 4 شرطة لخطف عسكري
        busy = false,
        label = 'Kidnap Police',
        icon = 'fa-shield-halved'
    }
}

-- الاجرام
Config.IllegalActions = {
    ['storerobbery'] = {
        minimumPolice = 2,
        busy = false,
        label = 'Store Robbery',
    },
    ['bankrobbery'] = {
        minimumPolice = 3,
        busy = false,
        label = 'Bank Robbery'
    },
    ['jewellery'] = {
        minimumPolice = 2,
        busy = false,
        label = 'Jewellery'
    },
    ['pacific'] = {
        minimumPolice = 5,
        busy = false,
        label = 'Pacific Bank'
    },
    ['paleto'] = {
        minimumPolice = 4,
        busy = false,
        label = 'Paleto Bay Bank'
    }
}

Config.ShowIDforALL = true